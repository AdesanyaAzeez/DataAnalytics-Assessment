WITH customer_plans AS (
-- fetch customer's savings and investment plans with deposit history
SELECT
	plans_plan.id AS plan_id,
    -- ssa.plan_id AS planid, -- crosscheck join
    -- plans_plan.owner_id,	-- crosscheck join
    ssa.owner_id,
    ssa.confirmed_amount,
    plans_plan.is_regular_savings,
    plans_plan.is_a_fund
    
FROM plans_plan
	JOIN savings_savingsaccount ssa	-- inner join to only capture plans with deposit history
		ON plans_plan.owner_id = ssa.owner_id
        AND plans_plan.id = ssa.plan_id
WHERE ssa.confirmed_amount > 0	-- ensure only funded records
	AND (plans_plan.is_regular_savings = 1 OR plans_plan.is_a_fund = 1)	-- filter for savings or investment plans
),
aggregated_customer_plans AS (
--  aggregate number of savings and investment plan, and totaldeposit by owner_id
SELECT
	owner_id,
    -- count unique regular_saving plan_id
    COUNT(DISTINCT CASE WHEN is_regular_savings = 1 THEN plan_id END) AS savings_count,
    -- count unique investment plan_id
    COUNT(DISTINCT CASE WHEN is_a_fund = 1 THEN plan_id END) AS investment_count,
    SUM(confirmed_amount) AS total_deposits
FROM customer_plans
GROUP BY owner_id
)
SELECT
	acp.owner_id,
    -- ucu.id, -- check join
    CONCAT(first_name, " ", last_name) AS `name`,
    savings_count,
    investment_count,
    ROUND(total_deposits, 2) AS total_deposits
    
FROM aggregated_customer_plans acp
	LEFT JOIN users_customuser ucu	-- join with customer details table
		ON acp.owner_id = ucu.id
WHERE investment_count >= 1	-- filter for record with atleast 1 investment plan
	AND savings_count >= 1	-- and atleast 1 savings plan
ORDER BY total_deposits;
