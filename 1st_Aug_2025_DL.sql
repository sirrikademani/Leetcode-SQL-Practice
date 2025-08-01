--1. https://datalemur.com/questions/sql-avg-review-ratings
SELECT 
extract(month from submit_date) as mth,
product_id,
round(avg(stars),2) as avg_stars
FROM reviews
group by 1,2
order by 1,2;

--2. https://datalemur.com/questions/amazon-shopping-spree
--Method1:
select 
distinct t1.user_id
from transactions t1
join transactions t2 on t1.user_id=t2.user_id
and t1.transaction_date::date=t2.transaction_date::date+1
join transactions t3 on t1.user_id=t3.user_id
and t1.transaction_date::date=t3.transaction_date::date+2 ;

--Method2: 
with cte as (SELECT user_id,
amount,
transaction_date as curr_date,
lag(transaction_date,1) over (partition by user_id order by transaction_date asc) as prev_day,
lag(transaction_date,2) over (partition by user_id order by transaction_date asc) as prevprev_day
FROM transactions)

select distinct user_id from cte where prev_day is not NULL
and prevprev_day is not null 
;

--3. https://datalemur.com/questions/histogram-users-purchases
/* 
With RANK():
The current query assigns the same rank to transactions that occur on the same date for a given user. This means if a user made multiple purchases on their most recent transaction date, all those purchases would have rank 1 and be included in the final result.
If ROW_NUMBER() was used:
It would assign a unique number to each transaction, even if they occurred on the same date. Only one transaction per user (the one arbitrarily chosen as "first" among those with the same latest date) would be selected.

Data:
user_id | product_id | transaction_date | spend
1       | A          | 2023-04-01       | 100
1       | B          | 2023-04-01       | 150
2       | C          | 2023-04-02       | 200
2       | D          | 2023-04-01       | 100
  
With RANK():
user_id | product_id | transaction_date | spend | rn
1       | A          | 2023-04-01       | 100   | 1
1       | B          | 2023-04-01       | 150   | 1
2       | C          | 2023-04-02       | 200   | 1
2       | D          | 2023-04-01       | 100   | 2

Result:
transaction_date | user_id | purchase_count
2023-04-01       | 1       | 2
2023-04-02       | 2       | 1
    
With ROW_NUMBER(): 
user_id | product_id | transaction_date | spend | rn
1       | A          | 2023-04-01       | 100   | 1
1       | B          | 2023-04-01       | 150   | 2
2       | C          | 2023-04-02       | 200   | 1
2       | D          | 2023-04-01       | 100   | 2

Result:
transaction_date | user_id | purchase_count
2023-04-01       | 1       | 1
2023-04-02       | 2       | 1

Key Difference:
RANK() will include all products purchased on the most recent day for each user, potentially showing multiple purchases per user on their latest transaction date.
ROW_NUMBER() would arbitrarily select one product from the most recent day for each user, always showing only one purchase per user.
*/
with recent_transactions as (
SELECT product_id,
user_id,
spend,
transaction_date,
rank() over (partition by user_id order by transaction_date desc) as rn 
FROM user_transactions)

select 
transaction_date,
user_id, 
count(product_id) as purchase_count 
from  recent_transactions
where rn=1
group by transaction_date, user_id
order by transaction_date
;

--4.https://datalemur.com/questions/alibaba-compressed-mode
--Method 1:
with cte as (SELECT 
 item_count,order_occurrences,
rank() over (order by order_occurrences desc) as rn 
FROM items_per_order
order by order_occurrences desc
)
select distinct item_count from cte where rn=1
;

--Method2:
SELECT distinct item_count from items_per_order
where order_occurrences = (select 
max(order_occurrences)
FROM items_per_order) 
;

--Method3:
select distinct item_count from 
items_per_order
where order_occurrences=(
SELECT mode() within group (order by order_occurrences desc ) as order_occurrences
from items_per_order
)
order by item_count 
;

--5.https://datalemur.com/questions/prime-warehouse-storage
/*floor(500000/prime_sq_ft)*prime_sq_ft)
Used to find Loss in the calculation:
This is often used when you want to:
- Calculate the maximum whole units possible within a budget
- Ensure you don't exceed a certain limit
- Get a conservative estimate that's slightly under the target number

USE OF FLOOR:
total_sqft = 800
500000/800 = 625
FLOOR(625) = 625
625 * 800 = 500,000 (In this case it matches because division is even)

total_sqft = 1600
500000/1600 = 312.5
FLOOR(312.5) = 312
312 * 1600 = 499,200
*/

with cte as (
select 
sum(case when item_type='prime_eligible' then 1 else 0 end) as total_prime_item,
sum(case when item_type='not_prime' then 1 else 0 end) as total_non_prime_item,
sum(case when item_type='prime_eligible' then square_footage else 0 end) as prime_sq_ft,
sum(case when item_type='not_prime' then square_footage else 0 end) as non_prime_sq_ft
from inventory
)

--floor is used to remove decimals and return rounded integers
--floor(500000/prime_sq_ft) would give-> sqft required for per prime item out of total 500,000 sqft
--floor(500000/prime_sq_ft)*total_prime_items --> total square feet occupied by prime items out of 500k Sqft 
select 
'prime_eligible' as item_type
,floor(500000/prime_sq_ft)*total_prime_item as item_count
 from cte 
UNION ALL 
select 
'not_prime' as item_type
,floor((500000 - floor(500000/prime_sq_ft)*prime_sq_ft)/non_prime_sq_ft)*total_non_prime_item as item_count
 from cte ;
