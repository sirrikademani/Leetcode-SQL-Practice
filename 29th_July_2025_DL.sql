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
