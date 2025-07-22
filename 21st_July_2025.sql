--1.https://leetcode.com/problems/find-category-recommendation-pairs/description/
with cte as (
    select distinct
    p1.product_id as p1pro, p1.category as p1cat,
    p2.product_id as p2pro, p2.category as p2cat
    from ProductInfo p1
    join ProductInfo p2 on p1.category < p2.category
)

select
p1cat as category1,
p2cat as category2,
count(distinct i1.user_id) as customer_count
from cte c
join ProductPurchases i1
on c.p1pro=i1.product_id
join ProductPurchases i2
on c.p2pro=i2.product_id
and i1.user_id=i2.user_id
group by 1,2 having count(distinct i1.user_id)>=3
order by 3 desc,1 asc,2 asc;


--2.https://leetcode.com/problems/first-letter-capitalization-ii/description/
with recursive temp as(
    select content_id, length(content_text) as lens, content_text
    from user_content
)

,temp2 as (
    select content_id, lens, 1 as id,  content_text, substring(content_text,1,1) as curr_letter
     from temp
     union all
     select content_id, lens, id+1,  content_text, substring(content_text,id+1,1) as curr_letter
     from temp2 where id <= lens
)

,temp3 as (select content_id, lens, id,  content_text, curr_letter ,
lag(curr_letter,1,' ') over (partition by content_id order by id) as prev_char 
from temp2)

,temp4 as (select content_id, lens, id,  content_text, curr_letter ,prev_char,
(case when prev_char=" " or (prev_char="-" and curr_letter between "a" and "z") then upper(curr_letter)
when curr_letter between "A" and "Z" then lower(curr_letter) 
else curr_letter
end) as next
from temp3)

select content_id, content_text as original_text,
group_concat(next order by id separator '') as converted_text from temp4
group by content_id
;

