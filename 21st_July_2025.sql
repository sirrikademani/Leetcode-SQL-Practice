--1.https://leetcode.com/problems/find-category-recommendation-pairs/description/
with cte as (
    select distinct
    p1.product_id as p1pro, p1.category as p1cat,
    p2.product_id as p2pro, p2.category as p2cat
    from ProductInfo p1
    join ProductInfo p2 on p1.category < p2.category
)

select
p1cat as category1,
p2cat as category2,
count(distinct i1.user_id) as customer_count
from cte c
join ProductPurchases i1
on c.p1pro=i1.product_id
join ProductPurchases i2
on c.p2pro=i2.product_id
and i1.user_id=i2.user_id
group by 1,2 having count(distinct i1.user_id)>=3
order by 3 desc,1 asc,2 asc;


select lb.book_id,
lb.title,
lb.author,
lb.genre,
lb.publication_year,
count(lb.record_id) as current_borrowers
from cte lb
where total_copies=0
group by 1,2,3,4,5
order by count(lb.record_id) desc,title asc


