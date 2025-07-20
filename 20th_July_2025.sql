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
