### EXPLANATIONS

**Assessment _Q1**
<br>To find customers with at least one funded savings plan AND one funded investment plan, I Inner-Joined the savings_savingsaccount table with the plans_plan table to get only plans with deposit history. Also, a filter to capture successful deposits and savings and investment plans only.

The result was aggregated to get the count of savings and investment plan for each customer along with their total deposit.

Finally, in the outer query, the aggregated result was joined with the users_customuser table to get the customer name, and the end result filtered to show only customers with atleast 1 funded saving and 1 funded investment plan.

**Assessment _Q2**
<br>In getting the average number of transactions per customer per month and categorizing them, I used a subquery to aggregate customers transaction on a monthly basis and then, an outer query to get the average for each customer.

In the outer-most query, I used a case statement to categorize customers based on a monthly average range, counted the numbers of customers in each category, and averaged all average in each category.

**Assessment _Q3**
<br>To find all active accounts (savings or investments) with no transactions in the last 1year (365 days), I did an Inner Join of the savings_savingsaccount table and plans_plan table to get only plans with deposit history and a filter to capture successful deposits and savings and investment plans.

In the 'customer_last_inflow' CTE, I created a type column to specify wether the plan is a savings or an investment, and get the last transaction date tied to the plan.

The outer query helps get neccessary column and the no_of_days since the last transaction date and filters for only record where last transaction date is lesser than 365days ago.

**Assessment _Q4**
<br>To get customer CLV, assuming the profit for each transaction is 0.1% of its value, transaction record is aggregated to show the count and average profit.

The aggregated result is joined with the users_customuser table to fetch customers name, tenure months - calculated as the no of months as at the current date from the date joined, and the CLV which is calculated based on a given formular - (total_transactions / tenure) * 12 * avg_profit_per_transaction).


**IMPORTANT NOTE:**
<br>The backticks(`) around some column alias are used to avoid keyword conflict. It is best practice to use them if the alias name are same as SQL reserved keywords.

### CHALLENGES
The task went smoothly overall, but there were a few things I had to pay attention to. I needed to make sure the joins were correct so the data didn't get duplicated or missed. I also worked on keeping the queries efficient and clear, avoiding complex scripts and using CTEs in place of subqueries for better readability.

Overall, there weren’t any major issues, but getting accurate results and keeping the queries clean took some careful work.




