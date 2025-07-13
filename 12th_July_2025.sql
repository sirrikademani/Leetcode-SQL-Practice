-- 1./*https://leetcode.com/problems/investments-in-2016/ ; Table: Insurance

select
round(sum(i1.tiv_2016),2) as tiv_2016
from insurance i1
where concat(lat,lon) not in (
    select concat(lat,lon) from Insurance i2
    where i1.pid <> i2.pid
)
and i1.tiv_2015 in (
select i3.tiv_2015
from insurance i3 
where i1.pid <> i3.pid
);

--2.https://leetcode.com/problems/big-countries/

select distinct name, 
population,
`area`
from World
where `area`>=3000000
or population>=25000000;

--3.https://leetcode.com/problems/classes-with-at-least-5-students/description/   ; (student, class) is the primary key (combination of columns with unique values) for this table.

select
class
from Courses
group by class having count(distinct student)>=5;

--4. https://leetcode.com/problems/human-traffic-of-stadium/description/

with filter as(
select * from stadium where people>99
),
grouped as(
    select *, id-row_number() over (order by id) as grp
    from filter
)
select id,visit_date,people 
from grouped 
where grp in (select distinct grp from grouped
group by grp having count(visit_date)>=3)
order by visit_date asc;

--5. https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/description/


with cte as(select
requester_id as id
from RequestAccepted
UNION ALL
select
accepter_id as id
from RequestAccepted)

select id,count(*) as num from cte
group by id order by count(*) desc limit 1;
