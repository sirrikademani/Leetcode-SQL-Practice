--1.https://datalemur.com/questions/teams-power-users
select sender_id, message_count from (
SELECT sender_id,
count(message_id) as message_count,
rank() over (order by count(message_id) desc) as rn 
FROM messages
where sent_date between '2022-08-01' and '2022-08-31'
group by 1) as ts 
where rn in (1,2)
;

--2. https://datalemur.com/questions/sql-highest-grossing
select category,
product,
total_spend from (
SELECT category,
product,
sum(Spend) as total_spend,
dense_rank() over (partition by category order by sum(spend) desc) as rn 
FROM product_spend
where extract(year from transaction_date)=2022
group by 1,2) temps 
where rn in (1,2);

--3.https://datalemur.com/questions/sql-top-three-salaries
with cte as (
SELECT e.name,
e.salary,
d.department_name,
dense_rank() over (partition by e.department_id order by salary desc) as rn
FROM employee e 
join department d on e.department_id=d.department_id)


select name, salary,department_name
from cte where rn<=3
order by department_name,salary desc, name asc 
;

--4.https://datalemur.com/questions/signup-confirmation-rate
SELECT 
round(count(t.email_id)::decimal/count(distinct e.email_id),2) as activation_rate
FROM emails e 
left join texts t on e.email_id=t.email_id 
and t.signup_action='Confirmed';

--5.https://datalemur.com/questions/yoy-growth-rate
with cte as (SELECT 
extract(year from transaction_date) as year,
product_id,
sum(spend) as curr_year_spend,
lag(sum(spend),1) over (partition by product_id order by extract(year from transaction_date) asc, sum(spend)) as prev_year_spend
FROM user_transactions
group by 1,2)

select year,product_id,
curr_year_spend,
prev_year_spend,
round(((curr_year_spend-prev_year_spend)/prev_year_spend)*100,2) as yoy_rate
from cte ;
