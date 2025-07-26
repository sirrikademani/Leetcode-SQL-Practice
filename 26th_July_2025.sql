--1.https://leetcode.com/problems/find-stores-with-inventory-imbalance/description/
with validstores as (
    select store_id,
    max(price) as max_price,
    min(price) as min_price
    from inventory 
group by 1 having count(distinct product_name)>=3
)

,calc as (
    select v.store_id,
    i_exp.product_name as most_exp_product,
    i_c.product_name as cheapest_product,
    round((i_c.quantity/i_exp.quantity),2) as imbalance_ratio
    from validstores v
    join inventory i_exp on v.store_id=i_exp.store_id
    and v.max_price=i_exp.price
    join inventory i_c on v.store_id=i_c.store_id
    and i_c.price=v.min_price
    where i_exp.quantity<i_c.quantity
)

select 
s.store_id,
s.store_name,
s.location,
c.most_exp_product,
c.cheapest_product,
c.imbalance_ratio
from stores s
join calc c on s.store_id=c.store_id 
order by c.imbalance_ratio desc,s.store_name asc  ;

--2.https://leetcode.com/problems/analyze-organization-hierarchy/description/
with recursive leadership as(
    select manager_id ,employee_id ,employee_name ,salary,1 as level
    from Employees 
    where manager_id is null
    union all
    select e.manager_id ,e.employee_id ,e.employee_name ,e.salary,level+1 level
    from Employees e
    join leadership l
    on e.manager_id =l.employee_id 
),
subordinate as(
    select employee_id ,salary ,manager_id 
    from Employees 
    union all
    select e.employee_id ,e.salary ,s.manager_id 
    from Employees e
    join subordinate s
    on s.employee_id=e.manager_id 
)
,
final as(
    select l.employee_id,l.employee_name,level,
    count(s.employee_id) as team_size ,
    ifnull(sum(s.salary),0)+l.salary as budget 
    from leadership l
    left join subordinate s
    on s.manager_id=l.employee_id
    group by 1,2,3,l.salary
)
select * from final
order by 3, 5 desc,2;
