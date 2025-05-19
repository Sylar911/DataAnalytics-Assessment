-- The query uses Common Table Expressions (CTEs) to first calculate monthly transaction counts per user,
-- then aggregates this data to classify users by their transaction frequency, and finally groups the output
-- by transaction category.

WITH transaction_counts AS (
    -- This CTE calculates the number of deposit transactions for each user grouped by month.
    SELECT         owner_id, 
        EXTRACT(YEAR_MONTH FROM transaction_date) AS month, -- Extracts year and month (format YYYYMM) to identify the transaction month.
        COUNT(*) AS monthly_transactions                    -- Counts the number of transactions in that month.
    FROM savings_savingsaccount
    GROUP BY owner_id, month                                  -- Groups by owner and month to get monthly totals.
),
Transaction_Table AS (
    -- This CTE aggregates the monthly transaction counts per user and assigns a transaction category.
    SELECT 
        CASE 
            WHEN AVG(tc.monthly_transactions) >= 10 THEN 'High Frequency'  -- If the average is 10 or more, label as high frequency.
            WHEN AVG(tc.monthly_transactions) BETWEEN 3 AND 9 THEN 'Medium Frequency'  -- If average is between 3 and 9, label as medium frequency.
            ELSE 'Low Frequency'  -- Otherwise, label as low frequency.
        END AS transaction_category,
        AVG(tc.monthly_transactions) AS avg_transactions_per_month,  -- Average transactions per month for the user.
        SUM(tc.monthly_transactions) AS Transaction_Count            -- Total transaction count across all months for the user.
    FROM users_customuser u
    JOIN transaction_counts tc ON u.id = tc.owner_id  -- Join users with their monthly transaction counts.
    GROUP BY u.id, u.name, u.email                    -- Group by unique user identifiers to aggregate the data per user.
)
-- Final query: Aggregate the individual users' transaction details by their transaction category.
SELECT 
    transaction_category,                                              -- The frequency category (High, Medium, Low).
    SUM(Transaction_Count) AS customer_count,                          -- The sum of all transactions for users in that category.
    AVG(avg_transactions_per_month) AS avg_transactions_per_month        -- The average transactions per month across users in that category.
FROM Transaction_Table
GROUP BY transaction_category
ORDER BY avg_transactions_per_month DESC;                             -- Order by the average transactions per month in descending order.
