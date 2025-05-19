 /* no 3*/
SELECT
    account_id AS plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM (
  -- Savings accounts with no deposit transaction in the last 365 days
  SELECT 
     savings_id AS account_id,
      s.owner_id AS owner_id,
      'Savings' AS type,
      MAX(s.transaction_date) AS last_transaction_date
  FROM savings_savingsaccount s
  GROUP BY s.savings_id, s.owner_id
  HAVING MAX(s.transaction_date) < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
  
  UNION ALL
  
  -- Investment accounts from plans_plan with no transaction in the last 365 days
  SELECT 
      p.id AS account_id,
      p.owner_id AS owner_id,
      'Investment' AS type,
      MAX(p.created_on) AS last_transaction_date
  FROM plans_plan p
  GROUP BY p.id, p.owner_id
  HAVING MAX(p.created_on) < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
) AS inactive_accounts
ORDER BY inactivity_days DESC;


-- The outer query selects the final results from our combined (unioned) inactive accounts.
SELECT
    account_id AS plan_id,   -- Renames the account identifier as 'plan_id' for consistent output.
    owner_id,                -- The ID of the account owner.
    type,                    -- A literal indicating if the account is a 'Savings' or an 'Investment' account.
    last_transaction_date,   -- The most recent transaction date for the account.
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days  -- Computes the number of days since the last transaction.
FROM (
  -- Begin union: first part captures inactive savings accounts.
  
  -- Savings accounts: Aggregates deposit transactions to find the latest for each savings account.
  SELECT 
     savings_id AS account_id,         -- Uses the unique savings account identifier from the savings table.
     s.owner_id AS owner_id,           -- Retrieves the owner of the savings account.
     'Savings' AS type,                -- Labels these records as 'Savings'.
     MAX(s.transaction_date) AS last_transaction_date  -- Determines the most recent deposit transaction date for the account.
  FROM savings_savingsaccount s         -- From the table recording savings deposit transactions.
  GROUP BY s.savings_id, s.owner_id       -- Groups the transactions by each account (savings_id) and its owner.
  HAVING MAX(s.transaction_date) < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
        -- Filters to include only accounts whose last deposit occurred more than 365 days ago.
  
  UNION ALL
  
  -- Investment accounts: Aggregates records from the plans table treated as investment transactions.
  SELECT 
      p.id AS account_id,             -- Uses the unique plan identifier from the plans table as the account identifier.
      p.owner_id AS owner_id,         -- Retrieves the owner of the investment plan.
      'Investment' AS type,           -- Labels these records as 'Investment'.
      MAX(p.created_on) AS last_transaction_date  -- Uses the plan's creation date as a proxy for the last transaction date.
  FROM plans_plan p                    -- From the plans table that records account plans, representing investments.
  GROUP BY p.id, p.owner_id             -- Groups by each investment plan and its owner.
  HAVING MAX(p.created_on) < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
        -- Filters to include only investment accounts whose creation (or "transaction") date is more than 365 days old.
        
) AS inactive_accounts  -- The subquery combines both inactive savings and investment accounts.
ORDER BY inactivity_days DESC;  -- Orders the final results by inactivity (days since last transaction) in descending order.
