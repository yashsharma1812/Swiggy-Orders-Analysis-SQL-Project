## Creating Database 
CREATE DATABASE swiggy

SELECT * FROM swiggy.items

SELECT * FROM swiggy.orders

-- Calculating the Distinct Food Items Ordered
SELECT COUNT(DISTINCT(name)) AS no_of_items FROM swiggy.items

-- Count of vegitarian and non-vegetarian items 
SELECT is_veg,COUNT(name) FROM swiggy.items
GROUP BY is_veg


-- Count of number of unique orders
SELECT COUNT(DISTINCT(order_id)) FROM swiggy.orders


-- Showing items containing chicken in their name
SELECT * FROM swiggy.items
WHERE name LIKE '%CHICKEN%'


-- Calculating average no. of items per order
SELECT count(name)/count(distinct order_id) as avgitemsperorder FROM swiggy.items


-- Finding the items ordered most number of times
SELECT name,count(*) FROM swiggy.items
group by name
order by count(*) desc


-- Unique restaurant names
SELECT count(distinct restaurant_name) FROM swiggy.orders


-- Restaurant with most orders
SELECT restaurant_name,count(*) FROM swiggy.orders
group by restaurant_name
order by count(*) desc


-- orders placed per month and year
SELECT right(order_time,7) as month_year,count(distinct order_id) FROM swiggy.orders
group by right(order_time,7)
order by count(distinct order_id) desc

-- Calculating Revenue made during differnet months
SELECT right(order_time,7) as month_year,sum(order_total) as totalrevenue
FROM swiggy.orders
group by right(order_time,7)
order by totalrevenue desc

-- Calculating Average order value
SELECT sum(order_total)/count(distinct order_id) as average_order_value
FROM swiggy.orders


-- change in revenue during consecutive years 
with final as (
SELECT right(order_time,4) as yearorder,sum(order_total) as revenue
FROM swiggy.orders
group by right(order_time,4))
select yearorder,revenue,lag(revenue) over (order by yearorder) as previousrevenue
from final


-- ranking the years with highest revenue
with final as (
SELECT right(order_time,4) as yearorder,sum(order_total) as revenue
FROM swiggy.orders
group by right(order_time,4))
select yearorder,revenue,
rank() over (order by revenue desc) as ranking from final


-- Restaurant with highest revenues
with final as (
SELECT restaurant_name,sum(order_total) as revenue
FROM swiggy.orders
group by restaurant_name)
select restaurant_name,revenue,
rank() over (order by revenue desc) as ranking from final
order by revenue desc


-- checking the orders and its respective items details by joining both the tables
SELECT a.name,a.is_veg,b.restaurant_name,b.order_id,b.order_time FROM swiggy.items a
join swiggy.orders b
on a.order_id=b.order_id


-- checking which items were ordered together
SELECT a.order_id,a.name,b.name as name2,concat(a.name,"-",b.name) FROM swiggy.items a
join swiggy.items b
on a.order_id=b.order_id
where a.name!=b.name
and a.name<b.name