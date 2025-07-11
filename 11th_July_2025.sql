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

# Write your MySQL query statement below
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
round(sum(case when delivery_type='immediate' then 1 else 0 end)/count(delivery_id)*100,2) as immediate_percentage
from cte;

--4. 550. Game Play Analysis IV
/* Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.

Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to determine the number of players who logged in on the day immediately following their initial login, and divide it by the number of total players.

The result format is in the following example.*/

select
round(count(distinct player_id)/(select count(distinct player_id) from activity),2) as fraction
from Activity 
where (player_id,date_sub(event_date, INTERVAL 1 day))
in (select player_id, min(event_date) as first_login
from activity group by player_id);

--5. 2356. Number of Unique Subjects Taught by Each Teacher
/*Table: Teacher
+-------------+------+
| Column Name | Type |
+-------------+------+
| teacher_id  | int  |
| subject_id  | int  |
| dept_id     | int  |
+-------------+------+
(subject_id, dept_id) is the primary key (combinations of columns with unique values) of this table.
Each row in this table indicates that the teacher with teacher_id teaches the subject subject_id in the department dept_id.

Write a solution to calculate the number of unique subjects each teacher teaches in the university.

Return the result table in any order.
The result format is shown in the following example. */

select
teacher_id, count(distinct subject_id) as cnt
from Teacher
group by 1;
 

