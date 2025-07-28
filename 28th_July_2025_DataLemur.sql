--1.https://datalemur.com/questions/sql-page-with-no-likes
SELECT 
distinct p.page_id
FROM pages p
left join page_likes pl on p.page_id=pl.page_id
where pl.page_id is null 
order by p.page_id asc;

--2.https://datalemur.com/questions/tesla-unfinished-parts
SELECT part,
assembly_step
FROM parts_assembly
where finish_date is null ;

--3.https://datalemur.com/questions/sql-third-transaction
with cte as (SELECT *,
row_number() over (partition by user_id order by transaction_date asc ) as third_transaction_no
FROM transactions)

select user_id,spend,transaction_date
from cte where third_transaction_no=3 ;

--4. https://datalemur.com/questions/sql-second-highest-salary
/* Second Highest Salary*/
--Method1:
SELECT max(salary) as second_highest_salary
FROM employee
where salary<(select max(salary) from employee);

--Method2:
with cte as (SELECT *,
dense_rank() over (order by salary desc) as rn
FROM employee
)

select distinct salary from cte where rn=2;

--5.https://datalemur.com/questions/supercloud-customer
WITH supercloud_cust AS (
  SELECT 
    customers.customer_id, 
    COUNT(DISTINCT products.product_category) AS product_count
  FROM customer_contracts AS customers
  INNER JOIN products 
    ON customers.product_id = products.product_id
  GROUP BY customers.customer_id
)

SELECT customer_id
FROM supercloud_cust
WHERE product_count = (
  SELECT COUNT(DISTINCT product_category) FROM products
);
