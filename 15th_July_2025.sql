--1. https://leetcode.com/problems/find-total-time-spent-by-each-employee/description/
select event_day as `day`,
emp_id,
sum(out_time-in_time) as total_time
from Employees
group by 1,2;

--2. https://leetcode.com/problems/game-play-analysis-i/description/
select
player_id,
min(event_date) as first_login
from Activity
group by 1;

--3.https://leetcode.com/problems/trips-and-users/description/
with users_data as(
    select * from users
    where banned='No'
)

select
t.request_at as `Day`,
round(sum(case when status like 'cancelled_%' then 1 else 0 end)/count(*),2) as `Cancellation Rate`
from Trips t
join users_data u 
on t.client_id=u.users_id
join users_data u1 
on t.driver_id=u1.users_id
and t.request_at between '2013-10-01' and '2013-10-03'
group by 1
;

--4. https://leetcode.com/problems/customer-placing-the-largest-number-of-orders/
select
customer_number
from Orders
group by 1 having count(order_number) = (
select max(cnt) from (select count(order_number) as cnt
from Orders
group by customer_number ) as t
)
;

--OR 
select customer_number from orders
group by customer_number
order by count(*) desc
limit 1;

--5. https://leetcode.com/problems/reformat-department-table/
select
id,
sum(case when month='Jan' then revenue else null end) as Jan_Revenue,
sum(case when month='Feb' then revenue else null end) as Feb_Revenue,
sum(case when month='Mar' then revenue else null end) as Mar_Revenue,
sum(case when month='Apr' then revenue else null end) as Apr_Revenue,
sum(case when month='May' then revenue else null end) as May_Revenue,
sum(case when month='Jun' then revenue else null end) as Jun_Revenue,
sum(case when month='Jul' then revenue else null end) as Jul_Revenue,
sum(case when month='Aug' then revenue else null end) as Aug_Revenue,
sum(case when month='Sep' then revenue else null end) as Sep_Revenue,
sum(case when month='Oct' then revenue else null end) as Oct_Revenue,
sum(case when month='Nov' then revenue else null end) as Nov_Revenue,
sum(case when month='Dec' then revenue else null end) as Dec_Revenue
from Department
group by 1;

--6. https://leetcode.com/problems/movie-rating/description/
(SELECT u.name AS results
 FROM MovieRating mr
 JOIN Users u ON u.user_id = mr.user_id
 GROUP BY u.name
 ORDER BY COUNT(*) DESC, u.name ASC
 LIMIT 1)

UNION ALL

(SELECT m.title AS results
 FROM MovieRating mr
 JOIN Movies m ON m.movie_id = mr.movie_id
 WHERE mr.created_at BETWEEN '2020-02-01' AND '2020-02-29'
 GROUP BY m.title
 ORDER BY AVG(mr.rating) DESC, m.title ASC
 LIMIT 1);
