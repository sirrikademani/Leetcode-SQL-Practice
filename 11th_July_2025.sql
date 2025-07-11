-- #1. You are given the list of Facebook friends and the list of Facebook pages that users follow. 
-- # Your task is to create a new recommendation system for Facebook. For each Facebook user, find pages that this user doesn't follow but at least one of their friends does. 
-- # Output the user ID and the ID of the page that should be recommended to this user.

select distinct uid,page_id from (
select users_friends.user_id uid,friend_id,page_id 
from users_friends join users_pages 
on users_friends.friend_id = users_pages.user_id) as a
where concat(uid,page_id) not in  (select concat(user_id ,page_id) from users_pages);

-- #2. Count the number of movies for which Abigail Breslin was nominated for an Oscar.
select count(distinct movie) as n_movies
from oscar_nominees
where nominee='Abigail Breslin';


-- #3 Table: Delivery
/*
+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the column of unique values of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 

If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.*/

with first_orders as(
select customer_id,min(order_date) as first_order
from Delivery
group by 1
)

, cte as (
    select d.customer_id,
    d.delivery_id,
case when d.customer_pref_delivery_date=d.order_date then 'immediate'
else 'scheduled' end as delivery_type
from Delivery d
join first_orders f
on d.order_date=f.first_order
and d.customer_id=f.customer_id
)

select 
sum(case when delivery_type='immediate' then 1 else 0 end)/count(delivery_id)*100 as immediate_percentage
from cte;
