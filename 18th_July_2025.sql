--1. https://leetcode.com/problems/calculate-special-bonus/
select
employee_id,
case when
employee_id%2 != 0 and
lower(substr(name,1,1)) <> 'm'
then salary else 0 end as bonus
from Employees 
order by employee_id ;

--2. https://leetcode.com/problems/daily-leads-and-partners/description/
select date_id,
make_name,
count(distinct lead_id) as unique_leads,
count(distinct partner_id) as unique_partners
from DailySales
group by 1,2;

--3. https://leetcode.com/problems/the-latest-login-in-2020/description/
select 
user_id,
max(`time_stamp`)as last_stamp
from Logins
where year(time_stamp)=2020
group by 1;

--4.https://leetcode.com/problems/count-salary-categories/description/
--Method 1:
SELECT 'Low Salary' AS category, COUNT(*) AS accounts_count FROM Accounts WHERE income < 20000 
UNION
SELECT 'Average Salary' AS category, COUNT(*) AS accounts_count FROM Accounts WHERE income >= 20000 AND income <= 50000
UNION
SELECT 'High Salary' AS category, COUNT(*) AS accounts_count FROM Accounts WHERE income > 50000 ;

--Method 2:
with cte as (
    select 
    account_id,
    case  
        when income < 20000 then 'Low Salary'
        when income >= 20000 and income <=50000 then 'Average Salary'
        when income > 50000 then 'High Salary'
        end as category
    from Accounts
)
#need a table of category to make left join 
#>>> prevent  those category without value in CTE from disappearing 
,cte1 as (
select 'Low Salary' as category
UNION 
select 'Average Salary' as category
UNION 
select 'High Salary' as category
)

select
cte1.category,
count(cte.account_id) as accounts_count
from cte1
left join cte
on cte1.category=cte.category
group by 1
;

--5. https://leetcode.com/problems/employees-with-missing-information/description/
--Method 1:
select distinct employee_id from(
select
e.employee_id as employee_id
from Employees e
left join Salaries s
on e.employee_id=s.employee_id
where s.salary is null

UNION 
select
s.employee_id as employee_id
from Employees e
right join Salaries s
on e.employee_id=s.employee_id
where e.name is null) as temp
order by 1
;

--Method 2:
select employee_id from (
select s.employee_id
from salaries s 
where not exists (
    select 1 from employees e
    where e.employee_id=s.employee_id
)

UNION 

select e.employee_id
from employees e
where not exists (select 1 from salaries s where s.employee_id=e.employee_id)
) t 
order by employee_id
;

--6.https://leetcode.com/problems/odd-and-even-transactions/description/
select 
transaction_date,
sum(case when amount%2 != 0 then amount else 0 end) as odd_sum,
sum(case when amount%2 = 0 then amount else 0 end) as even_sum
from 
transactions
group by 1 
order by 1;

--7.https://datalemur.com/questions/matching-skills
with cte as(SELECT candidate_id,
count(skill) as skills
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
group by 1)

select candidate_id from cte where skills=3;
