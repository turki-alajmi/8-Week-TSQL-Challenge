/* ---------------------------------------------------------------------------
-- Case Study #3: Foodie-Fi
-- Section D: Outside The Box Questions
-- Author: Turki Alajmi
-- Date: March 2026
-- Tool used: Microsoft SQL Server (T-SQL)
--------------------------------------------------------------------------- */

------------------------------------------------------------------------
-- Q1: How would you calculate the rate of growth for Foodie-Fi?
------------------------------------------------------------------------

WITH totals AS (
    SELECT
        DATENAME(MONTH, start_date) AS month,
        SUM(amount_paid) AS month_payments,
        DATEPART(MONTH, start_date) AS date_order
    -- Note payment is a newly made table from section C
    FROM foodie_fi.payments
    GROUP BY
        DATENAME(MONTH, start_date),
        DATEPART(MONTH, start_date)
),
    previous AS (
        SELECT
            month,
            month_payments,
            LAG(month_payments) OVER (
                ORDER BY date_order
                ) AS lagged_payment,
            date_order
        FROM totals
    )
SELECT
    month,
    month_payments,
    ISNULL(CAST(100.0 * ((month_payments - lagged_payment) / lagged_payment) AS DECIMAL(5, 1)), 0)
        AS monthly_growth_percent
FROM previous;

------------------------------------------------------------------------
-- Q2: What key metrics would you recommend Foodie-Fi management to track
-- over time to assess performance of their overall business?
------------------------------------------------------------------------


/*
Recommended Key Business Metrics:

1. Net Subscriber Growth: The ratio of new paid subscriptions versus churned
   accounts. If churn outpaces acquisition, the platform is shrinking.
2. Trial-to-Paid Conversion Rate: The percentage of users on a free trial
   (plan_id = 0) who successfully transition to a paid tier.
3. Monthly Recurring Revenue (MRR): Tracking total revenue month-over-month
   to monitor the financial health of the platform (as calculated in Q1).
4. Average Revenue Per User (ARPU): Monitoring if users are trending towards
   cheaper basic plans or more lucrative pro/annual plans.
*/


------------------------------------------------------------------------
-- Q3: What are some key customer journeys or experiences that you would
-- analyse further to improve customer retention?
------------------------------------------------------------------------


/*
Immediate post-trial churn — product fit or pricing issue?
Trial-to-paid conversion breakdown by plan — are customers avoiding pro?
Long-term basic monthly customers — upgrade opportunity or satisfaction ceiling?
Customers who churned after being on a paid plan — what triggered the exit?
*/


------------------------------------------------------------------------
-- Q4: If the Foodie-Fi team were to create an exit survey shown to
-- customers who wish to cancel their subscription, what questions
-- would you include in the survey?
------------------------------------------------------------------------

/*
Exit Survey Questions:

1. What was the primary reason for cancelling your subscription?
   (Price, Content Quality, Found a Better Alternative, No Longer Needed)
2. How would you rate your overall experience with Foodie-Fi? (1-10)
3. Are you considering subscribing to a competing service? If so, which one?
4. Would you recommend Foodie-Fi to a friend or colleague?
5. What would bring you back to Foodie-Fi?
*/

------------------------------------------------------------------------
-- Q5: What business levers could the Foodie-Fi team use to reduce the
-- customer churn rate? How would you validate the effectiveness of
-- your ideas?
------------------------------------------------------------------------

/*
Business Levers to Reduce Churn:

1. Extend the free trial from 7 days to 30 days — a week is insufficient
   for customers to complete a series and experience the platform's full value.
   Validation: Compare trial-to-paid conversion rates before and after the change.

2. Introduce a win-back discount (e.g. 50% off) for customers who have been
   churned for 3+ months.
   Validation: Track how many churned customers reactivate.
*/