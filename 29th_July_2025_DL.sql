--1.https://datalemur.com/questions/laptop-mobile-viewership
--Method 1
SELECT 
count(DISTINCT case when device_type='laptop' then user_id else null end) as laptop_reviews,
count(distinct case when device_type in ('tablet','phone') then user_id else null end) as mobile_views
FROM viewership;

--Method2
SELECT 
sum(case when device_type ='laptop' then 1 else 0 end) as laptop_reviews,
sum(case when device_type in ('phone','tablet') then 1 else 0 end) as mobile_views
FROM viewership;

--2.https://datalemur.com/questions/time-spent-snaps
SELECT 
ab.age_bucket,
round((sum(case when activity_type='open' then time_spent end)/sum(case when activity_type in ('send','open') then time_spent end))*100.0,2) as open_perc,
round((sum(case when activity_type='send' then time_spent end)/sum(case when activity_type in ('send','open') then time_spent end))*100.0,2) as send_perc
FROM activities a 
left join age_breakdown ab on a.user_id=ab.user_id
group by age_bucket order by age_bucket
;

--3.https://datalemur.com/questions/rolling-average-tweets
SELECT
user_id,
tweet_date,
round(avg(tweet_count) over (partition by user_id order by tweet_date rows between 2 PRECEDING and CURRENT row),2)
as rolling_avg_3rd
from tweets
;

--4. https://datalemur.com/questions/sql-average-post-hiatus-1
with cte as (SELECT user_id,
min(post_date) as min_dt,
max(post_Date) as max_dt
FROM posts
where EXTRACT(YEAR from post_date)=2021
group by 1 having count(post_id)>=2)

select user_id,
(max_dt::date-min_dt::date) as days_between
from cte 
;

--5.https://datalemur.com/questions/user-retention
select 
extract(month from cm.event_date) as "month"
,count(distinct cm.user_id) as monthly_active_users
from user_actions cm
where exists (
select pm.user_id
from user_actions pm
where
pm.user_id=cm.user_id and 
extract(month from pm.event_date)=extract(month from cm.event_date - interval '1 month')
) 
and extract(month from cm.event_date)=7
and extract(year from cm.event_date)=2022 
group by 1
;
