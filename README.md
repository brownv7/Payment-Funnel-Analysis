# Payment-Funnel-Analysis
Friction in online payment Process
#  Analyzing Subscription Payment Funnel & Identifying Conversion Bottlenecks:



#  Executive Summary:

This analysis investigates the reasons behind a significant number of unpaid subscriptions, suggesting potential friction within the online payment process. By leveraging SQL and a data science notebook to construct a product funnel analysis, this project identifies key pain points within the payment portal and provides actionable recommendations to improve the conversion rate of successful payments, ultimately mitigating the negative impact on revenue.

# Methodology:

* EDA
* Product Funnel Analysis
* Data Visualization
  
![BDE Data Model](https://github.com/user-attachments/assets/0d27eb95-343c-4181-8575-5e0fb1ba06f1)
![BDE Funnel](https://github.com/user-attachments/assets/337c702c-d971-4719-9f25-583d6fa4cb2d)



# Business Problem:

The finance team has noticed that many subscriptions haven't been paid for, so they've reached out to the product team to understand if there are any frictions points in the online payment portal so they can increase the conversion rate **(20.3% of subscriptions that are successfully converting to a paid subscription)**.

![BDE percent conversion 2024-12-31 224531](https://github.com/user-attachments/assets/90799a8d-b994-4c17-a131-126951cdef64)


## Skills

-   SQL
    -   CTEs, CASE, subqueries, window functions
    -   Note: Window functions are in bonus code solution
-   Data visualization
-   Data Wrangling
-   Data Cleaning
-   Data Science Notebook
-   Snowflake Data warehouse

## Results & Business Recommendation:

**Results:**

-   **16.95% of subscriptions have hit an error**


-   **40.7% of subscriptions have no opened the payment portal**
![image](https://github.com/user-attachments/assets/82e54fa7-d8b0-461f-ab98-02f4ffa8851c)
![BDE Payment funnel conver2024-12-31 223135](https://github.com/user-attachments/assets/24dd7d29-f360-4f6d-b9df-9d171a238885)
![BDE percent_funnel_stage 2024-12-31 224118](https://github.com/user-attachments/assets/55a6ace1-373e-447c-b30d-ee7dcf8e64b8)


**Business Recomendations:**

-   Reduce friction on the enter payment page by considering Apple Pay, Google Pay, or other payment methods that don't require entering in a credit card every time. This     will help reduce user errors due to incorrect payment info.
-   Reach out to the 3rd party payment processing vendor and inquire about the errors on their side and determine a plan reduce those in the future.
-   Work with the product manager to increase the number of subscriptions that are opening the payment portal and attempting to pay. Since a large number of subscriptions aren't even going into the payment portal, we're losing a large number of opportunities at the beginning of the funnel, so maybe we can set up payment reminders or have customer service agent call them to encourage payment.

## Next Steps:
- Investigate the error breakdown further to determine which errors are most common (user errors or vendor errors)
- Investigate why subscriptions aren't even starting the payment process. Is it a process issue on our side? Are customers forgetting?
