WITH monthly_customer_avg AS
(
-- get the average transaction count for each customer
SELECT
	owner_id,
    AVG(transaction_count) avg_transaction
FROM (
	-- get monthly transaction count for each customer
    SELECT
		owner_id,
		MONTH(transaction_date) AS `month`,
		COUNT(*) transaction_count
	FROM savings_savingsaccount
	GROUP BY owner_id, MONTH(transaction_date)    
	) sub1
GROUP BY owner_id
)
SELECT
	CASE 
		WHEN avg_transaction >= 10 THEN "High Frequency"
        WHEN avg_transaction >= 3 AND avg_transaction < 10  THEN "Medium Frequency"
	ELSE "Low Frequency"
	END AS frequency_category, -- category based on customers average
    COUNT(DISTINCT owner_id) AS customer_count,	-- no of users in the category
    ROUND(AVG(avg_transaction), 1) AS avg_transactions_per_month -- overall average of all users in category
    
FROM monthly_customer_avg
GROUP BY frequency_category;
