-- This query calculates an estimated customer lifetime value (CLV) for each customer,
-- based on the number of savings transactions, the customer's tenure, and the average 
-- confirmed deposit amount. The results are grouped by customer and ordered by the estimated CLV.

SELECT 
    u.id AS customer_id, -- Retrieves the unique customer ID from the users_customuser table and aliases it as customer_id.
    CONCAT(first_name, " ", Last_name) AS Name, -- Concatenates first_name and Last_name with a space to create the full customer name.
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months, -- Calculates the customer's tenure by finding the difference in months between today's date and the date the customer joined.
    COUNT(savings_id) AS total_transactions, -- Counts the number of savings transactions (each record representing a transaction) for the customer.
    ROUND(
        (COUNT(savings_id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) 
        * 12 
        * (0.001 * AVG(s.confirmed_amount))
    , 2) AS estimated_clv -- Computes the estimated customer lifetime value (CLV), 
                         -- which is based on the annualized average of transactions combined with a weighted factor of the average confirmed amount.
                         -- The result is rounded to 2 decimal places.
FROM users_customuser u -- The main table containing customer data.
JOIN savings_savingsaccount s 
    ON u.id = s.owner_id -- Joins the savings_savingsaccount table to match each customer with their respective deposit transactions.
GROUP BY u.id, u.name -- Groups the results by customer to allow aggregation (transaction count and averages) for each individual.
ORDER BY estimated_clv DESC; -- Orders the final results in descending order so that the customers with the highest estimated CLV appear first.
