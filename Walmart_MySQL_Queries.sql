create database walmart;
use walmart;
select * from walmart;

select count(*) from walmart;
select  payment_method,
       count(*)
from walmart group by payment_method;
select count(distinct Branch)
from walmart;
select min(quantity) from walmart;
-- Business Problems
-- Q.1 find different payment method and number of Transactions,number of qty sold
select  payment_method,
       count(*) as transactions,
       sum(quantity) as no_qty_sold
from walmart group by payment_method;

-- Q.2 Identify the highest-rated category in each branch,displaying the branch,category
-- AVG Rating
SELECT *  
FROM (  
    SELECT  
        Branch,  
        category,  
        AVG(rating) AS avg_rating,  
        RANK() OVER (PARTITION BY Branch ORDER BY AVG(rating) DESC) AS ranks  
    FROM walmart  
    GROUP BY Branch, category  
) AS ranked_table  -- Added alias here  
WHERE ranks = 1;


-- Q.3 Identify the busiest day for each branch on the number transactions
SELECT * 
FROM ( 
    SELECT 
        branch,  
        DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name,     
        COUNT(*) AS no_transactions,     
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS ranks  
    FROM walmart  
    GROUP BY branch, day_name 
) AS ranked_table  
WHERE ranks = 1;
-- Q.4  determine the average,minimum, and maximum rating of products for each city,
-- List the city,average_rating,min_rating, and max_rating.

select city,
		category,
        min(rating) as min_rating,
        max(rating) as max_rating,
        avg(rating) as avg_rating
from walmart
group by city,category;
-- Q.5 calculate the total profit for each category by considering total_profit as 
-- (unit_price * quantity * profit_margin). List category and total_profit,ordered from highest to lower profit
select category,
		sum(total) as total_revenue,
		sum(total* profit_margin) as profit
from walmart
group by category;
-- Q.6 Determine the most common payment method for each Branch
-- Display Branch and the preferred_payment_method
with cte
as
(select
	Branch,
    payment_method,
    count(*) as total_trans,
    rank() over(partition by Branch order by count(*) desc) as ranks
from walmart
group by Branch,payment_method
)
select * from cte
where ranks=1;
-- 	Q.7
-- 2022 sales
WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
    GROUP BY branch
)
SELECT
    ls.branch,
    ls.revenue AS last_year_revenue,
    cs.revenue AS cr_year_revenue,
    ROUND((ls.revenue - cs.revenue) / ls.revenue * 100, 2) AS revenue_drop_percent
FROM revenue_2022 AS ls
JOIN revenue_2023 AS cs
ON ls.branch = cs.branch
WHERE ls.revenue > cs.revenue
order by 4 desc
limit 5




