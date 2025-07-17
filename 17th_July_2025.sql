--1. https://leetcode.com/problems/rearrange-products-table/description/
select * from (
select
product_id,
'store1' as store,
store1 as price
from Products
where store1 is not null
UNION
select
product_id,
'store2' as store,
store2 as price
from Products
where store2 is not null
UNION
select
product_id,
'store3' as store,
store3 as price
from Products
where store3 is not null
)temp order by product_id
;

--2. https://leetcode.com/problems/capital-gainloss/description/
--Method 1:
with cte as (select 
stock_name,
sum(case when operation='Buy' then price else 0 end)as buying_price,
sum(case when operation='Sell' then price else 0 end)as selling_price
from Stocks 
group by 1)

select
stock_name,
(selling_price-buying_price) as capital_gain_loss
from cte
;

--Method 2:
select
stock_name,
sum(case when operation='Buy' then -price else price end) as capital_gain_loss
from Stocks
group by 1;


--3.https://leetcode.com/problems/top-travellers/description/
select
u.name,
coalesce(sum(r.distance),0) as travelled_distance
from Users u
left join Rides r
on u.id=r.user_id
group by u.id 
order by 2 desc, 1 asc;

--4. https://leetcode.com/problems/bank-account-summary-ii/description/
select
u.name,
sum(t.amount) as balance
from Users u
join Transactions t
on u.account=t.account
group by 1 having sum(t.amount)>10000
;

--5.https://leetcode.com/problems/average-time-of-process-per-machine/description/
--Method1: Optimised and easy
select
a1.machine_id,
round(avg(a2.timestamp-a1.timestamp),3) as processing_time
from Activity a1
join Activity a2
on a1.machine_id=a2.machine_id
and a1.process_id=a2.process_id
where a1.activity_type='start'
and a2.activity_type='end'
group by 1;

--Method 2: Complex
with cte as (
select machine_id,
process_id,
round(max(case when activity_type='start' then `timestamp` else 0 end ),3) as start_time,
round(max(case when activity_type='end' then `timestamp` else 0 end ),3) as end_time
from Activity
group by 1,2
)

select
machine_id,
round(avg(end_time-start_time),3) as processing_time
from cte
group by 1
order by 2 desc;

--6.https://leetcode.com/problems/fix-names-in-a-table/
select user_id,
concat(
    upper(
        substr(name,1,1)
    ),
    lower(
        substr(name,2)
    )
) as name
from users
order by 1;
