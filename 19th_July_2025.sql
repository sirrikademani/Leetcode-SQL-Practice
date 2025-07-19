--1. https://leetcode.com/problems/find-consistently-improving-employees/description/
with cte as(
    select employee_id
    from performance_reviews
group by 1 having count(review_id)>=3
)

, cte1 as(
select
distinct p.*
from performance_reviews p
join cte c on p.employee_id=c.employee_id
)

,cte2 as (select *,
dense_rank() over (partition by employee_id order by review_date desc) as rk
 from cte1
 order by 1,rk)
 
 ,cte3 as(select * from cte2 
 where rk<=3 order by employee_id)
 
,cte4 as( select *,
max(case when rk=1 then rating end) as rating1,
max(case when rk=2 then rating end) as rating2,
max(case when rk=3 then rating end) as rating3
  from cte3 group by employee_id order by 1)

select e.employee_id,
e.name,
(rating1-rating3) as improvement_score 
 from cte4
 join employees e on cte4.employee_id=e.employee_id
where rating1>rating2 and rating2>rating3
order by improvement_score desc, name asc
 ;

--2.https://leetcode.com/problems/find-covid-recovery-patients/description/
WITH first_positive AS (
    SELECT patient_id, MIN(test_date) AS first_pos_date
    FROM covid_tests
    WHERE result = 'Positive'
    GROUP BY patient_id
),
first_negative_after_positive AS (
    SELECT ct.patient_id, MIN(ct.test_date) AS first_neg_date
    FROM covid_tests ct
    JOIN first_positive fp ON ct.patient_id = fp.patient_id
    WHERE ct.result = 'Negative' AND ct.test_date > fp.first_pos_date
    GROUP BY ct.patient_id
)
SELECT 
    p.patient_id,
    p.patient_name,
    p.age,
    DATEDIFF(fn.first_neg_date, fp.first_pos_date) AS recovery_time
FROM first_positive fp
JOIN first_negative_after_positive fn ON fp.patient_id = fn.patient_id
JOIN Patients p ON p.patient_id = fp.patient_id
ORDER BY recovery_time ASC, p.patient_name ASC;

--3.https://leetcode.com/problems/sales-analysis-iii/description/
select
distinct p.product_id,
p.product_name
from Product p
join Sales s
on p.product_id=s.product_id
group by 1,2
having min(sale_date)>='2019-01-01'
and max(sale_date)<='2019-03-31'
;
