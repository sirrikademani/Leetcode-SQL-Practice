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

--2.https://leetcode.com/problems/find-invalid-ip-addresses/
/*
For: length(ip) - length( replace(ip, '.', '') ) = 3
Ex: ip = '172.16.254.1'
LENGTH(ip) = 13
REPLACE(ip, '.', '') = '172162541' → length = 10
So: 13 - 10 = 3 → Correct! There are 3 dots.*/

with cte as(select
*,
substring_index(ip,'.',1) as split1,
substring_index(substring_index(ip,'.',2),'.',-1) as split2,
substring_index(substring_index(ip,'.',3),'.',-1) as split3,
substring_index(substring_index(ip,'.',4),'.',-1) as split4
from logs
where (length(ip)-length(replace(ip,'.',''))=3)
)

,cte2 as(select * from cte
where split1<=255
and split2<=255 and split3<=255 and split4<=255
and split1 not like '0%'
and split2 not like '0%'
and split3 not like '0%'
and split4 not like '0%')

select ip,count(*) as invalid_count from
logs where ip not in (
select ip from cte2)
group by ip 
order by invalid_count desc,ip desc;
