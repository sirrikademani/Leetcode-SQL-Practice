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

--2.
