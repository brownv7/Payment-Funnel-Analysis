--Review subscriptions that have used the payment portal and their status with description.
select  
    *
from 
    public.payment_status_log psl
join
    public.payment_status_definitions def
    on psl.status_id = def.status_id
order by
    subscription_id,
    movement_date;

--Using MAX() status to track the furthest point in the workflow each subscription reaches, even if they hit errors.

select  
    psl.subscription_id,
    max(psl.status_id)  as  max_status
from 
    public.payment_status_log psl
group by
    1;


--Tracking subscriptions met with errors using the Funnel Stages

with max_status_reach as (

select  
    psl.subscription_id,
    max(psl.status_id)  as  max_status
from 
    public.payment_status_log psl
group by
    1
)
,
payment_funnel_stages as (
select
    subs.subscription_id,
    date_trunc('year', order_date) as order_year,
    current_payment_status,
    max_status,
    case when max_status = 1 then 'Payment Widget Opened'
        when max_status = 2 then 'Payment Entered'
        when max_status = 3 and current_payment_status = 0 then 'User Error with Payment Submission'
        when max_status = 3 and current_payment_status != 0 then 'Payment Submitted'   
        when max_status = 4 and current_payment_status = 0 then 'Payment Processing Error with Vendor'
        when max_status = 4 and current_payment_status != 0 then 'Payment Success w/ Vendor' 
        when max_status = 5 then 'Complete'
        when max_status  is null then 'User Has Not Started Payment Process'
        end as payment_funnel_stage
from 
    public.subscriptions subs
left join
    max_status_reach m
    on subs.subscription_id = m.subscription_id
)
select  
    payment_funnel_stage,
    order_year,
    count(*) as num_subs
from
    payment_funnel_stages
group by
    1,2
order by
    2 desc

--Percentage of conversion

with max_status_reach as (

select  
    psl.subscription_id,
    max(psl.status_id)  as  max_status
from 
    public.payment_status_log psl
group by
    1
)
,
payment_funnel_stages as (

select
    subs.subscription_id,
    date_trunc('year', order_date) as order_year,
    current_payment_status,
    max_status,
    case when max_status = 5 then 1 else 0 end as completed_payment,
    case when max_status is not null then 1 else 0 end as started_payment

from 
    public.subscriptions subs
left join
    max_status_reach m
    on subs.subscription_id = m.subscription_id
)
select 
   -- order_year
    sum(completed_payment) as num_subs_completed_payment,
    sum(started_payment) as num_subs_started_payment,
    count(*) as total_subs,
    round(num_subs_completed_payment * 100 / total_subs,2) as conversion_rate,
    round(num_subs_completed_payment * 100 / num_subs_started_payment,2) as workflow_completion_rate
from
    payment_funnel_stages
