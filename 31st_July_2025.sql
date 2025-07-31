--1.https://datalemur.com/questions/duplicate-job-listings
select count(*) from (SELECT company_id FROM job_listings
group by company_id,title,description having count(title)>1)ts ;

--2.https://datalemur.com/questions/completed-trades
select city,total_orders from (
SELECT 
u.city,
count(tt.order_id) as total_orders,
rank() over (order by count(tt.order_id) desc) as rn
FROM trades tt 
join users u on tt.user_id=u.user_id
where tt.status='Completed'
group by u.city
order by count(tt.order_id) desc, u.city
) ss 
where rn<=3
;

--3.https://datalemur.com/questions/odd-even-measurements 
select 
measurement_day,
sum(case when (num%2)!=0 then measurement_value else 0 end) as odd_sum ,
sum(case when (num%2)=0 then measurement_value else 0 end) as even_sum  
from (
SELECT measurement_time ,
measurement_time::date as measurement_day,
measurement_value,
row_number() over (partition by measurement_time::date order by measurement_time) as num
FROM measurements
)ss 
group by 1
;

--4.https://datalemur.com/questions/sql-swapped-food-delivery
with total_count as(
select count(order_id) as total_orders from orders
) 

,cte as(SELECT order_id,
item,
case when order_id%2!=0 and order_id!=total_orders then order_id+1 
when order_id%2!=0 and order_id=total_orders then order_id
else order_id-1 end as corrected_order_id
 FROM orders
 cross join total_count
 )
 
SELECT
corrected_order_id, item 
from cte order by corrected_order_id;

--5.https://datalemur.com/questions/sql-bloomberg-stock-min-max-1
--Method 1 using min() and max() functions
with high as (
select ticker,
to_char(date,'Mon-YYYY') as highest_mth,
max(open) as highest_open,
row_number() over (partition by ticker order by open desc ) as rn 
from stock_prices
group by 1,2,open
)

, low as (
select ticker,
to_char(date,'Mon-YYYY') as lowest_mth,
min(open) as lowest_open,
row_number() over (partition by ticker order by open asc ) as rn 
from stock_prices
group by 1,2,open
)

select h.ticker,
highest_mth,
highest_open,
lowest_mth,
lowest_open
from high h 
join low l 
on h.ticker=l.ticker
and h.rn=1 
and l.rn=1
;

--Method2: without min() or max()
with high as (
select ticker,
to_char(date,'Mon-YYYY') as highest_mth,
open as highest_open,
row_number() over (partition by ticker order by open desc ) as rn 
from stock_prices

)

, low as (
select ticker,
to_char(date,'Mon-YYYY') as lowest_mth,
open as lowest_open,
row_number() over (partition by ticker order by open asc ) as rn 
from stock_prices

)

select h.ticker,
highest_mth,
highest_open,
lowest_mth,
lowest_open
from high h 
join low l 
on h.ticker=l.ticker
and h.rn=1 
and l.rn=1
;
