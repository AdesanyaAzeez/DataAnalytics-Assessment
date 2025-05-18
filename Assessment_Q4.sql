WITH user_transaction_history AS (
-- extract user transaction and profit
SELECT
	ssa.owner_id,
    confirmed_amount,
    -- calc. profit as 0.1% of transaction value
    (0.001 * confirmed_amount) AS profit
FROM savings_savingsaccount ssa
),
aggregated_custominfo AS (
-- aggregate transaction count and profit for each user
SELECT
	owner_id,
    COUNT(*) AS total_transactions,
    AVG(profit) AS avg_profit_per_transaction
FROM user_transaction_history
GROUP BY owner_id
)
SELECT
	owner_id AS customer_id,
    CONCAT(first_name, " ", last_name) AS `name`,
    TIMESTAMPDIFF(MONTH, ucu.date_joined, NOW()) AS tenure_months, -- no of month(s) since customer joined
    total_transactions,
    -- customer clv as (total_transactions / tenure) * 12 * avg_profit_per_transaction)
    ROUND(
    (total_transactions / TIMESTAMPDIFF(MONTH, ucu.date_joined, NOW())) * 12 * avg_profit_per_transaction
    , 2) AS estimated_clv
		
FROM aggregated_custominfo aci
    LEFT JOIN users_customuser ucu
		ON aci.owner_id = ucu.id

ORDER BY estimated_clv DESC; -- sort result by estimated CLV from highest to lowest
