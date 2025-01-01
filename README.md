# Payment-Funnel-Analysis
Friction in online payment Process
#  Analyzing Subscription Payment Funnel & Identifying Conversion Bottlenecks:



#  Executive Summary:

This analysis investigates the reasons behind a significant number of unpaid subscriptions, suggesting potential friction within the online payment process. By leveraging SQL and a data science notebook to construct a product funnel analysis, this project identifies key pain points within the payment portal and provides actionable recommendations to improve the conversion rate of successful payments, ultimately mitigating the negative impact on revenue.

# Methodology:
<img  src="/api/v1/file/cae5ffd4-ba3e-4c27-829b-9b8323f29900"  width="1200"  />

<img  src="/api/v1/file/e260a6a2-12b2-4b54-aaa7-898399e53e7f"  width="900"  />


* EDA
* Product Funnel Analysis
* Data Visualization


# Business Problem:

The finance team has noticed that many subscriptions haven't been paid for, so they've reached out to the product team to understand if there are any frictions points in the online payment portal so they can increase the conversion rate **(20.3% of subscriptions that are successfully converting to a paid subscription)**.

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

-   Add visualizations here to support your insights and claims
    -   Add neat titles and labels to make your visualization clear
-   **16.95% of subscriptions have hit an error**
-   **40.7% of subscriptions have no opened the payment portal**

  

**Business Recomendations:**

-   Reduce friction on the enter payment page by considering Apple Pay, Google Pay, or other payment methods that don't require entering in a credit card every time. This will help reduce user errors due to incorrect payment info.
-   Reach out to the 3rd party payment processing vendor and inquire about the errors on their side and determine a plan reduce those in the future.
-   Work with the product manager to increase the number of subscriptions that are opening the payment portal and attempting to pay. Since a large number of subscriptions aren't even going into the payment portal, we're losing a large number of opportunities at the beginning of the funnel, so maybe we can set up payment reminders or have customer service agent call them to encourage payment.

## Next Steps:
- Investigate the error breakdown further to determine which errors are most common (user errors or vendor errors)
- Investigate why subscriptions aren't even starting the payment process. Is it a process issue on our side? Are customers forgetting?
