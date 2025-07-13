-- 1./*https://leetcode.com/problems/investments-in-2016/ ; Table: Insurance
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| pid         | int   |
| tiv_2015    | float |
| tiv_2016    | float |
| lat         | float |
| lon         | float |
+-------------+-------+
pid is the primary key (column with unique values) for this table.
Each row of this table contains information about one policy where:
pid is the policyholder's policy ID.
tiv_2015 is the total investment value in 2015 and tiv_2016 is the total investment value in 2016.
lat is the latitude of the policy holder's city. It's guaranteed that lat is not NULL.
lon is the longitude of the policy holder's city. It's guaranteed that lon is not NULL.
Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
have the same tiv_2015 value as one or more other policyholders, and
are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
Round tiv_2016 to two decimal places.
*/
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
/*name is the primary key (column with unique values) for this table.
Each row of this table gives information about the name of a country, the continent to which it belongs, its area, the population, and its GDP value.
A country is big if:

it has an area of at least three million (i.e., 3000000 km2), or
it has a population of at least twenty-five million (i.e., 25000000).
Write a solution to find the name, population, and area of the big countries.

Return the result table in any order.

The result format is in the following example.*/
select distinct name, 
population,
`area`
from World
where `area`>=3000000
or population>=25000000;

--3.https://leetcode.com/problems/classes-with-at-least-5-students/description/   ; (student, class) is the primary key (combination of columns with unique values) for this table.
/*Each row of this table indicates the name of a student and the class in which they are enrolled.
Write a solution to find all the classes that have at least five students.
Return the result table in any order.
The result format is in the following example.*/
select
class
from Courses
group by class having count(distinct student)>=5;

--4. https://leetcode.com/problems/human-traffic-of-stadium/description/
/*Table: Stadium
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| visit_date    | date    |
| people        | int     |
+---------------+---------+
visit_date is the column with unique values for this table.
Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
As the id increases, the date increases as well.
Write a solution to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.
Return the result table ordered by visit_date in ascending order.*/
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
/*Table: RequestAccepted
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
(requester_id, accepter_id) is the primary key (combination of columns with unique values) for this table.
This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.
Write a solution to find the people who have the most friends and the most friends number.

The test cases are generated so that only one person has the most friends.
The result format is in the following example.*/

with cte as(select
requester_id as id
from RequestAccepted
UNION ALL
select
accepter_id as id
from RequestAccepted)

select id,count(*) as num from cte
group by id order by count(*) desc limit 1;
