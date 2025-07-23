--1.https://leetcode.com/problems/find-books-with-no-available-copies/description/
select 
lb.book_id,
lb.title,
lb.author,
lb.genre,
lb.publication_year,
borrowed_count as current_borrowers
from library_books lb
join (select book_id,count(record_id) as borrowed_count
from borrowing_records 
where return_date is null
group by book_id) br 
using(book_id)
where total_copies-borrowed_count=0
order by borrowed_count desc, title;

--2.https://leetcode.com/problems/find-overbooked-employees/description/
 with cte as (select 
 employee_id,
 yearweek(meeting_date,3) as weeks,
 sum(duration_hours) as meeting_hrs
 from meetings
 group by employee_id,weeks )
 
,cte1 as (select *,count(*) as meeting_heavy_weeks from cte
where meeting_hrs>20
group by employee_id having count(*)>=2)

select e.employee_id,e.employee_name, department, meeting_heavy_weeks
from cte1 c left join
employees e
using (employee_id)
order by meeting_heavy_weeks desc, e.employee_name

