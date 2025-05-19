-- Select customer information along with their savings and investment plan details.
SELECT 
    u.id AS owner_id, -- Retrieves the user ID from the users_customuser table and aliases it as 'owner_id'
    CONCAT(first_name, " ", last_name) AS Name, -- Combines the first and last names into a single column called 'Name'
    COUNT(s.savings_id) AS Saving_Count, -- Counts the number of deposit transactions (each identified by savings_id) for the customer
    COUNT(plan_id) AS Investment_Count, -- Counts the number of plans linked to the customer via plan_id
    SUM(s.confirmed_amount) AS total_deposits -- Sums the confirmed deposit amounts from the savings transactions
FROM 
    users_customuser u -- Base table that contains customer details, aliased as 'u'
JOIN 
    plans_plan p ON u.id = p.owner_id -- Join the plans_plan table to get the customer's plans; matching user id with plan owner_id
JOIN 
    savings_savingsaccount s ON p.id = s.plan_id -- Join the savings_savingsaccount table to access the deposit transactions; linking via the plan id
WHERE 
    s.confirmed_amount > 0 -- Include only transactions where the confirmed amount is positive
    AND p.amount > 0       -- Include only plans with a positive amount, ensuring valid investment plan records
GROUP BY 
    u.id, u.name -- Group results by the user ID and (assumed) name to aggregate the counts and sums correctly
ORDER BY 
    total_deposits DESC; -- Sort the results by the total deposits in descending order (highest depositing customers appear first)
