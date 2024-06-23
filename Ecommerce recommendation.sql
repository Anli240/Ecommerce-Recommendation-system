
create database ecommerce

select * from interactions

select * from past_purchases

-- 1.	Select all records from the Products table

select * from products

-- 2.	 Filter products by category 'Electronics'

select * from products where category = 'Electronics'

-- 3. Sort products by price in descending order

select * from products order by price desc

-- 4.	Count the number of interactions

select * from interactions

select count(*) as interaction_count from interactions

-- 5.	Calculate the total purchase amount for each user

select * from past_purchases

select user_id , sum(total_amount) as total_amount_purchase from past_purchases group by user_id

-- 6.	Retrieve the oldest purchase date

select min(purchase_date) as oldest_purchase from past_purchases

-- 7.	Join Products and Interactions to get product details with interaction type
select * from past_purchases 
select * from interactions

select * from products p 

select p.*, i.interaction_type from products p join interactions i on p.ï»¿product_id = i.product_id

-- 8.	Subquery to find products with more than 10 interactions

select * from products where ï»¿product_id in ( select product_id from interactions group by product_id having count(*) > 10)

-- 9.	Update product price for a specific product

update products set price = 1500 where ï»¿product_id = "P001"
SET SQL_SAFE_UPDATES = 0;
set safe_updates = 0

-- 10.	Delete an interaction record

select * from interactions

delete from interactions where ï»¿interaction_id = 5

-- 11.	Retrieve the top 5 users with the highest total purchase amount

select * from past_purchases

select user_id, total_amount from past_purchases order by total_amount desc limit 5

-- 12.	Count the number of unique brands in the Products table
SELECT user_id, SUM(total_amount) AS total_purchase_amount 
FROM Past_Purchases 
GROUP BY user_id 
ORDER BY total_purchase_amount DESC 
LIMIT 5;
select * from products

select count(distinct brand) as total_unique_brands from products

-- 13.	Window function to rank products by price within each category


select ï»¿product_id , product_name, category, price, rank() over(partition by category order by price) as price_rankk from products

-- \14.	Common Table Expression (CTE) to find the average price of products

WITH AvgPrice AS (
    SELECT AVG(price) AS average_price FROM Products
)
SELECT * FROM Products WHERE price > (SELECT average_price FROM AvgPrice);

with avg_price as( select avg(price) as avrage_price from products)
 select * from products where price > (select avrage_price from avg_price)
 
 -- 15.	Create an index on the user_id column of the Past_Purchases table
 
  CREATE INDEX idx_user_id ON Past_Purchases("user_id");
  
  CREATE INDEX idx_user_id ON Past_Purchases(user_id);
  
  CREATE INDEX idx_user_id ON Past_Purchases(user_id(100));
  select * from past_purchases
  
  
  
  
  -- 16.	Retrieve the product with the highest total purchase amount
  
  select product_id, total_amount from past_purchases order by total_amount desc limit 1
  
-- 17.	Create a view to show interactions with product details
CREATE VIEW InteractionDetails AS
SELECT i.*, p.product_name, p.category, p.brand 
FROM Interactions i
JOIN Products p ON i.pro_id = p.product_id;

create view interactiondetails as select i.*, p.pro_id, p.category, p.brand 
from interactions i join products p on  p.pro_id = i.product_id
select * from interactiondetails
select * from products
select * from interactions


ALTER TABLE Products RENAME column product_id TO pro_id;


-- 18.	Rollback a transaction if an error occurs while updating interactions
START TRANSACTION;
UPDATE Interactions SET interaction_type = 'Click' WHERE ï»¿interaction_id = 10;
SAVEPOINT before_commit;
UPDATE Interactions SET interaction_type = 'View' WHERE ï»¿interaction_id = 11;
ROLLBACK TO before_commit;
COMMIT;

-- 19.	Count the number of interactions per product

SELECT product_id, COUNT(*) AS interaction_count
FROM Interactions
GROUP BY product_id;


select * from interactions

-- 20.	List top N most popular products based on interactions

select product_id, count(*) as interactions_count from interactions group by product_id order by interactions_count desc limit 3

-- 21.	Retrieve product details along with user interactions

select p.*, i.interaction_type, i.ï»¿interaction_id, i.user_id from products p join interactions i on p.pro_id = i.product_id

-- 22.	Find products with no interactions

select p.* from products p left join interactions i on p.pro_id = i.product_id where i.product_id is null

-- 23.	Rank products by price within each category using window functions
select * from products

select product_name, price, rank() over(partition by category order by price desc) as rank_ from products

-- 24.	Calculate the cumulative sum of total purchases by user

select * from past_purchases

SELECT user_id, ï»¿purchase_id, total_amount,
       SUM(total_amount) OVER (PARTITION BY user_id ORDER BY ï»¿purchase_id) AS cumulative_sum
FROM Past_Purchases;

select ï»¿purchase_id, user_id, total_amount, sum(total_amount) 
over(partition by user_id order by ï»¿purchase_id )as cummulative_sum  from past_purchases

-- 25.	Find products purchased more than once

select * from past_purchases

select * from products where pro_id  in ( select product_id from past_purchases group by product_id having count(*) > 1)

-- 26.	Retrieve interactions for products with prices above the average price

select * from interactions where product_id in ( select pro_id from products where price > (select avg(price) from products))

-- 27.	Create a CTE to calculate average product price by category

with avgpricebycategory as (select category, avg(price) as avg_Price from products group by category) 
select p.pro_id, p.product_name, p.price,  c.avg_price  from products p  join avgpricebycategory c on p.category = c.category


-- 28.	Use a CTE to find the top 3 users with the highest total purchase amounts
 
 select * from past_purchases
 


with userpurchasetotal as ( select user_id, sum(total_amount) as total_purchase from past_purchases group by user_id)
select user_id, total_purchase from userpurchasetotal order by total_purchase desc limit 3

-- 29.	Calculate the percentage contribution of each product to the total sales amount

select sum(price) from products

select * from products



with productsales as ( select product_id, sum(total_amount) as total_sales from past_purchases group by product_id)
select p.pro_id, p.product_name, p.price, ps.total_sales, (ps.total_sales / (select sum(total_amount) from past_purchases)) * 100 as per
from products p join productsales ps on p.pro_id = ps.product_id  


-- 30.	Identify users who made purchases of more than $500 in a single transaction

select * from past_purchases

select user_id, total_amount from past_purchases where total_amount > 500



-- 31.	Calculate the average time between consecutive purchases for each user

WITH UserPurchaseTimes AS (
    SELECT user_id, 
           purchase_date - LAG(purchase_date, 1) OVER (PARTITION BY user_id ORDER BY purchase_date) AS time_diff
    FROM Past_Purchases
)
SELECT user_id, AVG(time_diff) AS avg_time_between_purchases
FROM UserPurchaseTimes
GROUP BY user_id;

-- 32.	Identify products that have been interacted with but not purchased

select * from past_purchases
select distinct(interaction_type) from interactions

select product_id, interaction_type from interactions
 where interaction_type = 'view'
 
 SELECT i.product_id, p.product_name
FROM Interactions i
LEFT JOIN Past_Purchases pp ON i.product_id = pp.product_id
JOIN Products p ON i.product_id = p.pro_id
WHERE pp.product_id IS NULL;

-- 33.	Find users who made purchases in the first and last quarter of the year
select * from past_purchases

select user_id  from past_purchases where extract( quarter from purchase_date) = 1 or extract(quarter from purchase_date) = 4


-- 34.	Calculate the average quantity of products purchased by users who interacted with products priced above the average price

WITH InteractedProducts AS (
    SELECT DISTINCT user_id, product_id
    FROM Interactions
),
AvgProductPrice AS (
    SELECT AVG(price) AS avg_price
    FROM Products
)
SELECT ip.user_id, AVG(pp.quantity) AS avg_quantity
FROM InteractedProducts ip
JOIN Products p ON ip.product_id = p.pro_id
JOIN Past_Purchases pp ON ip.user_id = pp.user_id AND ip.product_id = pp.product_id
CROSS JOIN AvgProductPrice avgp
WHERE p.price > avgp.avg_price
GROUP BY ip.user_id;l


-- 35. Find users who have interacted with products across multiple categories:

SELECT user_id
FROM (
    SELECT user_id, COUNT(DISTINCT category) AS num_categories
    FROM Interactions i
    JOIN Products p ON i.product_id = p.pro_id
    GROUP BY user_id
) AS user_categories
WHERE num_categories > 1;