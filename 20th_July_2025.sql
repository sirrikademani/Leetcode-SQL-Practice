--1.https://leetcode.com/problems/find-valid-emails/description/
select *
from
Users 
where email regexp '^[A-Za-z0-9_]+@[A-Za-z]+\.com'  --^ symbol specifies beginning of string
order by user_id asc;

--2.https://leetcode.com/problems/find-products-with-valid-serial-numbers/description/
select * from products
where regexp_like(description,"\\bSN[0-9]{4}-[0-9]{4}\\b",'c')
order by 1;
/*The 'c' flag means:

"SN1234-5678" will match (uppercase SN)
"sN4321-8765" won't match (lowercase s)
"sn1234-5678" won't match (lowercase sn)*/

--3. https://leetcode.com/problems/dna-pattern-recognition/description/
select
*,
case when dna_sequence regexp '^(ATG)' then 1 else 0 end as has_start,
case when dna_sequence like '%TAA' or dna_sequence like '%TAG'
or dna_sequence like '%TGA' then 1 else 0 end as has_stop,
case when dna_sequence regexp "(ATAT)" then 1 else 0 end as has_atat,
case when dna_sequence regexp "G{3}" then 1 else 0 end as has_ggg
from Samples
order by sample_id;

--4.https://leetcode.com/problems/analyze-subscription-conversion/description/
select
user_id,
round(avg(case when activity_type='free_trial' then activity_duration else null end),2) as trial_avg_duration,
round(avg(case when activity_type='paid' then activity_duration else null end),2) as paid_avg_duration
from UserActivity
where user_id in (
    select user_id from UserActivity 
    where activity_type='paid'
)
group by user_id;

--5.https://datalemur.com/questions/sql-histogram-tweets
--Method 1:
with cte as (SELECT *,
row_number() over (partition by user_id order by count(distinct tweet_id) ) as tweet_bucket
FROM tweets
where year(tweet_date)=2022
group by tweet_id,	user_id,	msg,	tweet_date)

,cte1 as (SELECT
user_id,
max(tweet_bucket) as tweet_bucket
from cte 
group by 1)

select tweet_bucket,
count(distinct user_id) as USER_num
from cte1
 group by 1
;

--method 2:
select 
cnt as tweet_bucket,
count(user_id) as user_num
from(
SELECT
user_id,
count(tweet_id) as cnt 
from tweets
where year(tweet_date)=2022
group by 1) as TEMP_table
group by 1;
