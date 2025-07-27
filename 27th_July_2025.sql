--1.https://leetcode.com/problems/find-product-recommendation-pairs/description/
select
pp1.product_id as product1_id,
pp2.product_id as product2_id,
pi1.category as product1_category,
pi2.category as product2_category,
count(distinct pp1.user_id) as customer_count
from ProductPurchases pp1
inner join ProductPurchases pp2 on pp1.user_id=pp2.user_id
and pp1.product_id<pp2.product_id
left join ProductInfo pi1 on pp1.product_id=pi1.product_id
left join ProductInfo pi2 on pp2.product_id=pi2.product_id
group by pp1.product_id,pp2.product_id
having count(distinct pp1.user_id)>=3
order by count(distinct pp1.user_id) desc,  pp1.product_id, pp2.product_id asc
;
