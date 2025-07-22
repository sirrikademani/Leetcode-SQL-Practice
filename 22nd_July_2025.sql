--1.https://leetcode.com/problems/find-drivers-with-improved-fuel-efficiency/description/
with first_half_trips as(
    select driver_id,
    avg(distance_km/fuel_consumed) as first_half_avg
    from trips
    where trip_date between '2023-01-01' and '2023-06-30'
    group by 1
)

,second_half_trips as(
    select driver_id,
    avg(distance_km/fuel_consumed) as second_half_avg
    from trips
    where trip_date between '2023-07-01' and '2023-12-31'
    group by 1
)

select distinct
f.driver_id,
d.driver_name,
round(first_half_avg,2) as first_half_avg,
round(second_half_avg,2) as second_half_avg,
round((second_half_avg-first_half_avg),2) as efficiency_improvement
from first_half_trips f
join second_half_trips s on f.driver_id=s.driver_id
and second_half_avg > first_half_avg
join drivers d
on d.driver_id=f.driver_id
order by 5 desc,2 asc;


