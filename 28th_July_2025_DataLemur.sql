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
