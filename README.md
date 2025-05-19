**Question 1
Approach: 
**
1.	  Join Tables:
•	Connect users (users_customuser) with plans (plans_plan) using owner_id.
•	Link plans to savings transactions (savings_savingsaccount) using plan_id.
2.	 Select Required Data:
•	Get user ID (owner_id) and full name (CONCAT(first_name, last_name)).
•	Count savings transactions and investment plans.
•	Sum confirmed deposits.
3.	Filter Data:
•	Include only transactions where deposits are positive.
•	Ensure investment plans have valid amounts.
4.	Group & Sort:
•	Group by user to aggregate counts and sums.
•	Sort by total deposits in descending order.

Challenges: 
Too many Column in the data set 


**Question 2
Approach: **

1.  Use Common Table Expressions (CTEs):
•	transaction_counts calculates monthly transactions per user.
•	Transaction_Table assigns users a transaction frequency category based on their average monthly transactions.
2.  Join and Aggregate Data:
•	Join users_customuser with transaction_counts to group users by transaction behavior.
•	Categorize users based on transaction frequency (High, Medium, Low).
3.  Final Selection & Sorting:
•	Aggregate transaction categories to count total users per category.
•	Sort by average monthly transactions in descending order for insights.


**Question 3
Approach: 
**
1.  Identify Inactive Accounts:
•	Savings accounts: Find the latest deposit transaction per account.
•	Investment accounts: Use the plan creation date as the last transaction date.
2.  Filter Inactive Accounts:
•	Select accounts where the last transaction occurred more than 365 days ago.
3.  Combine Savings & Investment Accounts:
•	Use UNION ALL to merge inactive savings and investment accounts into a single dataset.
4.  Calculate Inactivity Duration:
•	Compute the number of days since the last transaction using DATEDIFF(CURDATE(), last_transaction_date).
5.  Sort by Inactivity:
•	Order results by inactivity days in descending order to prioritize the longest inactive accounts.

Challenge: 
Transaction date not available in Plan_plans Table: I had to use the creation DAte 


**Question 4
Approach: **

1.  Calculate Customer Tenure:
•	Use TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) to determine how long a customer has been active.
2.  Aggregate Transaction Data:
•	Count total savings transactions per customer using COUNT(savings_id).
3.  Estimate Customer Lifetime Value (CLV):
•	Compute CLV based on transaction frequency and average deposit amount.
•	Use ROUND(...) to ensure the result is rounded to two decimal places.
4.  Join Relevant Tables:
•	Connect users_customuser with savings_savingsaccount using owner_id.
5.  Group & Sort Results:
•	Group by customer ID and name to aggregate data correctly.
•	Sort by estimated_clv DESC to prioritize high-value customers.

