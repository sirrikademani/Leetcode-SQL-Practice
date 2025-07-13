--1. https://leetcode.com/problems/exchange-seats/
select
CASE when mod(id,2)=0 then id-1
     when mod(id,2)=1 and id+1 in (select id from seat) then id+1
     else id end as id,
     student
from Seat 
order by id
;

--2. https://leetcode.com/problems/customers-who-bought-all-products/description/
select customer_id
from Customer
group by customer_id having count(distinct product_key)=(
    select count(product_key) from Product
);

--3. https://leetcode.com/problems/actors-and-directors-who-cooperated-at-least-three-times/
with cte as(
select actor_id,director_id,
count(concat(actor_id,director_id)) as ct
from ActorDirector 
group by 1,2 having count(concat(actor_id,director_id))>=3)

select c.actor_id,c.director_id
from cte c;

--4. https://leetcode.com/problems/product-sales-analysis-i/description/
select product_name,
`year`,
price
from Sales s
left join Product p
on s.product_id=p.product_id
;

--5.https://leetcode.com/problems/product-sales-analysis-iii/description/
--Method1:
with cte as 
(select product_id,min(`year`) as first_year
from Sales
group by 1)

select s.product_id,first_year,quantity,price
from Sales s
join cte c on s.product_id=c.product_id
and s.`year`=c.first_year
;

--Method 2:
select product_id, `year` as first_year, 
quantity,  price
from Sales
where (product_id,`year`) in (
    select product_id,min(`year`) as first_year
    from Sales group by 1
);

--6.https://leetcode.com/problems/project-employees-i/description/
select
p.project_id,
round(avg(experience_years),2) as average_years
from Project p
join Employee e
on p.employee_id=e.employee_id
group by 1;

