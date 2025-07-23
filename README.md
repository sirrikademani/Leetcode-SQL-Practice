# Leetcode-SQL-Practice

https://docs.google.com/spreadsheets/d/1245OEIr4DJO-J7cYjbGvJcbZ8-W51A5vkZC7aPpzXAQ/edit?gid=0#gid=0

Committed to solve atleast 5 SQL questions everyday !

## Learnt on 23rd July 2025: USING clause
	The USING clause in SQL is a shorthand way to join tables when the column names used for the join are identical in both tables. Let me explain its function and benefits:
		1. Purpose: USING simplifies the JOIN syntax when the joining columns have the same name in both tables.
		2. How it works:
			○ It specifies the column(s) to join on.
			○ It automatically matches columns with the same name across the tables being joined.
		3. Comparison with ON clause:
			○ USING(column_name) is equivalent to ON table1.column_name = table2.column_name
			○ However, USING is more concise and readable, especially when joining on multiple columns.
		4. In your query: USING(book_id) joins the library_books table with the subquery result (t1) based on the book_id column.
		5. Example: JOIN table1 USING(id, date) is equivalent to JOIN table1 ON table1.id = table2.id AND table1.date = table2.date
		6. Advantages:
			○ Reduces redundancy in the query
			○ Improves readability
			○ Helps avoid ambiguity in column references
		7. Limitation: Can only be used when the join columns have identical names in both tables.
In summary, USING is a convenient shorthand in SQL that simplifies joins when column names match, making queries more concise and often easier to read and maintain.

Example: 
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
