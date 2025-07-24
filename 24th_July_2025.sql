--1. https://leetcode.com/problems/find-students-with-study-spiral-pattern/
with cte1 as(
    select *,
    row_number() over (partition by student_id order by session_date) as rn
    from study_sessions
)

,sequence_check as(
    select 
    *,
    datediff(session_date , 
    lag(session_date) over (partition by student_id order by session_date)) as date_gap 
    from cte1)

,cte2 as (select * from sequence_check
where date_gap is null or date_gap <= 2)

,cte3 as(select student_id,
count(rn) as total_sessions,
count(distinct subject) as cycle_length,
sum(hours_studied) as total_study_hours
from cte2
group by 1 having
cycle_length>=3 and total_sessions>=cycle_length*2)

select
s.student_id,
s.student_name,
s.major,
c.cycle_length,
c.total_study_hours
from cte3 c
join students s
on c.student_id=s.student_id
order by cycle_length desc, total_study_hours desc
;
