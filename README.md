# Leetcode-SQL-Practice

https://docs.google.com/spreadsheets/d/1245OEIr4DJO-J7cYjbGvJcbZ8-W51A5vkZC7aPpzXAQ/edit?gid=0#gid=0

Committed to solve SQL questions everyday in July 2025!

### 1. USING clause
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

### 2.YEARWEEK(date, 3)
YEARWEEK(date, 3) in MySQL returns a number in the format YYYYWW where:

YYYY is the year
WW is the week number (01-53)
The mode parameter "3" is particularly important:

It means weeks start on Monday
Week 1 is the first week with 4 or more days in the new year
Examples:
-- For date '2024-01-01' (Monday)
YEARWEEK('2024-01-01', 3) returns 202401

-- For date '2024-12-31' (Tuesday)
YEARWEEK('2024-12-31', 3) returns 202453

The different mode values (0-7) control:

When the week starts (Sunday or Monday)
How to determine week 1 of the year (first days or first complete week)
Mode 3 is commonly used because it follows the ISO-8601 standard where:

Weeks start on Monday
Week 1 is the week with January 4th
This might mean December 29-31 belong to week 1 of next year
Or early January dates might belong to week 52/53 of previous year
This function is useful for:

Grouping data by week
Financial reporting
Week-over-week comparisons

### 3. Rolling avg tweets for 3 days calc
avg(tweet_count) over (partition by user_id order by tweet_date rows between 2 PRECEDING and CURRENT row)

### 4. Difference between ROW_NUMBER() and RANK() function
With RANK():
The current query assigns the same rank to transactions that occur on the same date for a given user. This means if a user made multiple purchases on their most recent transaction date, all those purchases would have rank 1 and be included in the final result.
If ROW_NUMBER() was used:
It would assign a unique number to each transaction, even if they occurred on the same date. Only one transaction per user (the one arbitrarily chosen as "first" among those with the same latest date) would be selected.

Data:
user_id | product_id | transaction_date | spend
1       | A          | 2023-04-01       | 100
1       | B          | 2023-04-01       | 150
2       | C          | 2023-04-02       | 200
2       | D          | 2023-04-01       | 100
  
With RANK():
user_id | product_id | transaction_date | spend | rn
1       | A          | 2023-04-01       | 100   | 1
1       | B          | 2023-04-01       | 150   | 1
2       | C          | 2023-04-02       | 200   | 1
2       | D          | 2023-04-01       | 100   | 2

Result:
transaction_date | user_id | purchase_count
2023-04-01       | 1       | 2
2023-04-02       | 2       | 1
    
With ROW_NUMBER(): 
user_id | product_id | transaction_date | spend | rn
1       | A          | 2023-04-01       | 100   | 1
1       | B          | 2023-04-01       | 150   | 2
2       | C          | 2023-04-02       | 200   | 1
2       | D          | 2023-04-01       | 100   | 2

Result:
transaction_date | user_id | purchase_count
2023-04-01       | 1       | 1
2023-04-02       | 2       | 1

Key Difference:
RANK() will include all products purchased on the most recent day for each user, potentially showing multiple purchases per user on their latest transaction date.
ROW_NUMBER() would arbitrarily select one product from the most recent day for each user, always showing only one purchase per user.


