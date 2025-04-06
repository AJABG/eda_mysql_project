-- Recommended Analysis
-- What were the least and most ordered items? What categories were they in?

-- What do the highest spend orders look like? Which items did they buy and how much did they spend?

-- Were there certain times that had more or less orders?

-- Which cuisines should we focus on developing more menu items for based on the data?

-- let's start the analysis step by step 

-- 1 view the menu items table. 
SELECT 
    *
FROM
    restaurant_orders.menu_items;
-- 2 find the number of items on the menu.

SELECT 
    COUNT(*)
FROM
    menu_items;

-- 3 what are the least and most expensive items on the menu?

SELECT 
    *
FROM
    menu_items
ORDER BY price ASC;
-- least expensive items are Edamame and mac&cheese
SELECT 
    *
FROM
    menu_items
ORDER BY price DESC;
-- most expensive items are Shrimp scampi and korean beef bowl

-- 4 HOW many italian dishes are on the menu?

SELECT 
    COUNT(*)
FROM
    menu_items
WHERE
    category = 'Italian';
-- There are 9 italian dishes

-- 5 what are the least and most expensive italian dishes are on the menu?

-- for the least italian dishes
SELECT 
    *
FROM
    menu_items
WHERE
    category = 'Italian'
ORDER BY price;
--  for the most expensive italian dishes
SELECT 
    *
FROM
    menu_items
WHERE
    category = 'Italian'
ORDER BY price DESC;

-- 6 how many dishes are in each category?
SELECT 
    category, COUNT(menu_item_id) AS number_of_dishes
FROM
    menu_items
GROUP BY category;

-- 7 what is an average dish price in each category?

SELECT 
    category, floor(AVG(price)) AS average_price
FROM
    menu_items
GROUP BY category;
-- average dish prices are american = 10 , Asian = 13, Mexican = 11 and italian = 16

-- let's explore the orders table 
SELECT * FROM restaurant_orders.order_details;

-- 1 what is the date range of the table?
SELECT 
    MIN(order_date), MAX(order_date)
FROM
    order_details;
-- date range  1/1/23, 3/9/23


-- 2 how many orders were made within this date range?
SELECT 
    COUNT(DISTINCT order_id)
FROM
    order_details;
-- 5370 orders were made

-- 3 how many items were ordered within this date range?

SELECT COUNT(*) FROM order_details;
-- 12234 orders


-- 4 which orders had the most number of items?
SELECT order_id,COUNT(item_id) AS num_of_items FROM order_details
GROUP BY order_id
ORDER BY num_of_items DESC;
-- top two ids with most number of orders 330 and 440

-- 5 how many orders have more than 12 items ?
SELECT count(*) FROM
(SELECT order_id,COUNT(item_id) AS num_of_items FROM order_details
GROUP BY order_id
HAVING num_of_items > 12) as num_orders;
-- 20 orders have more than 12 items

-- 6 Combine the menu_items and order_details tables into a single table.
SELECT 
    *
FROM
    order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id;

-- 7 what were the least and most ordered items? what categories were they in?
-- FOR LEAST
SELECT 
    item_name, COUNT(ï»¿order_details_id) AS num_purchases
FROM
    order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY item_name
ORDER BY num_purchases;
-- FOR MOST
SELECT 
    item_name, COUNT(ï»¿order_details_id) AS num_purchases
FROM
    order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY item_name
ORDER BY num_purchases DESC;

-- AND CATEGORIES 
SELECT 
    item_name,category, COUNT(ï»¿order_details_id) AS num_purchases
FROM
    order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY item_name,category
ORDER BY num_purchases DESC;
-- there are multiple orders with details top two are Hamburger category american purchases 622
-- and edamame category asian purchases 620


-- 8 what were the top 5 orders that spent the most money?
SELECT order_id,FLOOR(sum(price)) as total_spent 
FROM
    order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spent DESC
limit 5; 

-- top order_ids that spent the most money 440 2075 1957 330 2675 

-- 9 view the details of the highest spend order. what insights can you gather from them
SELECT category,count(item_id) AS num_items
FROM	
	order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category ;
 

-- 10 view the details of top 5 highest spend orders . what insights can you gather from them
SELECT order_id,category,count(item_id) AS num_items
FROM	
	order_details od
        LEFT JOIN
    menu_items mi ON od.item_id = mi.menu_item_id
WHERE order_id IN (440,2075,1957,330,2675)
GROUP BY order_id,category;

-- order_id category num_items are mentioned. top 2 below 
-- 330 asian num_items 6 and American number_items 1

-- This concludes the data exploration phase.