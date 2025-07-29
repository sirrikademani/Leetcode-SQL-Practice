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
