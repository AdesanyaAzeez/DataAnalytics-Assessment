WITH customer_plan_activity AS (
-- fetch customer's savings and investment plans with deposit history
SELECT
	plans_plan.id AS plan_id,
    -- ssa.plan_id AS planid, -- crosscheck join
    -- plans_plan.owner_id,	-- crosscheck join
    ssa.owner_id,
    plans_plan.is_regular_savings,
    plans_plan.is_a_fund,
    ssa.transaction_date
    
FROM plans_plan
	JOIN savings_savingsaccount ssa	-- inner join to only capture plans with deposit history
		ON plans_plan.owner_id = ssa.owner_id
        AND plans_plan.id = ssa.plan_id
WHERE ssa.confirmed_amount > 0	-- ensure only funded records
	AND (plans_plan.is_regular_savings = 1 OR plans_plan.is_a_fund = 1)	-- filter for savings or investment plans
),
customer_last_inflow AS (
-- get customer's plan type and its last transaction date
SELECT
	plan_id,
    owner_id,
    CASE 
		WHEN is_regular_savings = 1 THEN "Savings"
		WHEN is_a_fund = 1 THEN "Investment"
	END AS `type`,
    MAX(transaction_date) AS last_transaction_date
FROM customer_plan_activity
GROUP BY plan_id, owner_id
)
SELECT
	plan_id,
    owner_id,
    `type`,
    DATE(last_transaction_date) AS last_transation_date,
    TIMESTAMPDIFF(DAY, last_transaction_date, NOW()) AS inactivity_days -- get no of days from last activity date
FROM customer_last_inflow
WHERE last_transaction_date <= DATE_SUB(NOW(), INTERVAL 365 DAY); -- filter for records more than 365days ago
