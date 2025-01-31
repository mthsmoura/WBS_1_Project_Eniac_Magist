USE magist;

-- How many orders are there in the dataset? --
SELECT COUNT(order_id) AS Count_Orders
FROM orders;

-- Are orders actually delivered? --
SELECT order_status, COUNT(*)
FROM orders
GROUP BY order_status;

-- Is Magist having user growth? --
SELECT YEAR(order_purchase_timestamp) AS Year,
MONTH(order_purchase_timestamp) AS Month,
COUNT(*) AS Sum
FROM orders
GROUP BY Year, Month
ORDER BY Year, Month ASC;

SELECT YEAR(order_purchase_timestamp) AS Year,
COUNT(*) AS Sum
FROM orders
GROUP BY Year
ORDER BY Year ASC;

-- How many products are there on the products table? --
SELECT COUNT(DISTINCT product_id) AS Products, product_category_name AS Category
FROM products
GROUP BY product_category_name;

-- Which are the categories with the most products? --
SELECT COUNT(DISTINCT product_id) AS Products, product_category_name AS Category
FROM products
GROUP BY product_category_name
ORDER BY Products DESC;

-- How many of those products were present in actual transactions? --
SELECT p.product_category_name AS Product_Category, COUNT(p.product_id) AS Quantity
FROM products AS p
INNER JOIN order_items AS o
ON p.product_id = o.product_id
GROUP BY Product_Category
ORDER BY Quantity DESC;

SELECT COUNT(DISTINCT product_id) AS Products
FROM order_items;

-- What’s the price for the most expensive and cheapest products? --
SELECT MAX(price) AS Maximum_Price, 
MIN(price) AS Minimum_Price,
ROUND(AVG(price),2) AS Average_Price
FROM order_items; 

-- What are the highest and lowest payment values? --
SELECT MAX(payment_value) AS Hightest,
MIN(payment_value) AS Lowest
FROM order_payments;

SELECT order_id, ROUND(SUM(payment_value),2) AS Payment
FROM order_payments
GROUP BY order_id
ORDER BY Payment DESC;