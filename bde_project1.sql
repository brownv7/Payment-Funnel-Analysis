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

--Tracking subscriptions met with errors using the Funnel Stages by year

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
    2 desc;

--Calculating Funnel statges without year using a CTE
with max_status_reached as (
select 
    subscription_id,
    max(status_id) as max_status
from 
    public.payment_status_log
group by
    1
)
,
subs_current_status as(
select
	subscription_id,
	status_id as current_status,
	movement_date,
	row_number() over(partition by subscription_id order by movement_date desc) as most_recent_status
from
	payment_status_log
qualify
	most_recent_status = 1
)
,
payment_funnel_stages as(
select
	subs.subscription_id,
    date_trunc('year', order_date) as order_year,
	current_status,
	max_status,
	case when max_status = 1 then 'Payment Widget Opened'
		when max_status = 2 then 'Payment Entered'
		when max_status = 3 and current_payment_status = 0 then 'User Error with Payment Submission'
		when max_status = 3 and current_payment_status != 0 then 'Payment Submitted'
		when max_status = 4 and current_payment_status = 0 then 'Payment Processing Error with Vendor'
		when max_status = 4 and current_payment_status != 0 then 'Payment Success w/ Vendor'
		when max_status = 5 then 'Complete'
        when max_status is null then 'User Has Not Started Payment Process'
		end as payment_funnel_stage
from
	subscriptions subs
left join
	max_status_reached m
	on subs.subscription_id = m.subscription_id
left join 
    subs_current_status curr
    on subs.subscription_id = curr.subscription_id
)
select 
    payment_funnel_stage,
    count(*) as num_subs
from 
    payment_funnel_stages
group by
    1

-- added script to convert to stages to percentages w/o year
SELECT
    payment_funnel_stage,
    count(*) as num_subs,
    round(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS percentage
FROM
    payment_funnel_stages
GROUP BY
    1
ORDER BY
    1;

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

--calculation for conversions
select  
    (select count(distinct subscription_id) from public.payment_status_log where status_id= 0) / count(*) as perc_subs_hit_error
from
    subscriptions
