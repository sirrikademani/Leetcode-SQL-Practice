#1. You are given the list of Facebook friends and the list of Facebook pages that users follow. 
# Your task is to create a new recommendation system for Facebook. For each Facebook user, find pages that this user doesn't follow but at least one of their friends does. 
# Output the user ID and the ID of the page that should be recommended to this user.

select distinct uid,page_id from (
select users_friends.user_id uid,friend_id,page_id 
from users_friends join users_pages 
on users_friends.friend_id = users_pages.user_id) as a
where concat(uid,page_id) not in  (select concat(user_id ,page_id) from users_pages);

#2. Count the number of movies for which Abigail Breslin was nominated for an Oscar.
select count(distinct movie) as n_movies
from oscar_nominees
where nominee='Abigail Breslin';
