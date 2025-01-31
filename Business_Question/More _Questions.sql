USE magist;

-- Categories of available products --
SELECT COUNT(product_id), product_category_name
FROM products
GROUP BY product_category_name;

-- Tech products --
SELECT COUNT(product_id), product_category_name
FROM products
WHERE product_category_name IN ('audio', 'eletronicos', 
'informatica_acessorios', 'pcs', 'relogios_presentes', 'telefonia', 'TABLETS_IMPRESSAO_IMAGEM')
GROUP BY product_category_name;

SELECT COUNT(product_category_name)
FROM products
WHERE product_category_name IN ('audio', 'eletronicos', 
'informatica_acessorios', 'pcs', 'relogios_presentes', 'telefonia', 'TABLETS_IMPRESSAO_IMAGEM');

-- Income with all categories --
SELECT ROUND(SUM(oi.price),2)
FROM order_items AS oi
LEFT JOIN orders AS o
ON oi.order_id = o.order_id;

-- Income with tech categories only --
SELECT p.product_category_name, ROUND(SUM(o.price),2)
FROM products AS p
LEFT JOIN order_items AS o
ON p.product_id = o.product_id
WHERE product_category_name IN ('audio', 'eletronicos', 'informatica_acessorios', 'pcs', 'relogios_presentes', 'telefonia', 'TABLETS_IMPRESSAO_IMAGEM')
GROUP BY product_category_name;

SELECT ROUND(SUM(o.price),2) AS Tech_price, ROUND(AVG(o.price),2) AS Avg_tech_price
FROM products AS p
LEFT JOIN order_items AS o
ON p.product_id = o.product_id
WHERE product_category_name IN ('audio', 'eletronicos', 
'informatica_acessorios', 'pcs', 'relogios_presentes', 'telefonia', 'TABLETS_IMPRESSAO_IMAGEM');

-- Top 10 tech products with price--
SELECT p.product_category_name, o.price
FROM products AS p
LEFT JOIN order_items AS o
ON p.product_id = o.product_id
WHERE product_category_name IN ('audio', 'eletronicos', 
'informatica_acessorios', 'pcs', 'relogios_presentes', 'telefonia', 'TABLETS_IMPRESSAO_IMAGEM')
ORDER BY price DESC
LIMIT 10;

-- Top 10 products with price --
SELECT COUNT(oi.product_id), 
CASE WHEN price > 1000 THEN 'Expensive'
	WHEN price >100 AND price < 999 THEN 'Medium'
    ELSE 'Cheap'
END AS Price_category
FROM order_items AS oi
LEFT JOIN products AS p
ON oi.product_id = p.product_id
WHERE product_category_name IN ('audio', 'eletronicos', 
'informatica_acessorios', 'pcs', 'relogios_presentes', 'telefonia', 'TABLETS_IMPRESSAO_IMAGEM')
GROUP BY Price_category;

-- Months included on the database --
SELECT YEAR(order_purchase_timestamp) AS Year, MONTH(order_purchase_timestamp) AS Month
FROM orders
GROUP BY Year, Month
ORDER BY Year ASC;

-- Quantity of sellers and tech sellers--
SELECT COUNT(DISTINCT seller_id) AS All_sellers
FROM sellers;

SELECT COUNT(DISTINCT s.seller_id), 
p.product_category_name AS Category
FROM sellers AS s
INNER JOIN order_items AS o
ON s.seller_id = o.seller_id
INNER JOIN products AS p
ON p.product_id = o.product_id
WHERE p.product_category_name IN ('audio', 'eletronicos', 
'informatica_acessorios', 'pcs', 'relogios_presentes', 'telefonia', 'TABLETS_IMPRESSAO_IMAGEM')
GROUP BY Category;

SELECT COUNT(DISTINCT s.seller_id) AS Tech_sellers
FROM sellers AS s
INNER JOIN order_items AS o
ON s.seller_id = o.seller_id
INNER JOIN products AS p
ON p.product_id = o.product_id
WHERE p.product_category_name IN ('audio', 'eletronicos', 'informatica_acessorios', 
'pcs', 'relogios_presentes', 'telefonia', 'TABLETS_IMPRESSAO_IMAGEM');

-- Total sell $ and tech sells $ --
SELECT 13591643.70 / 3095 / 25;
SELECT 2882054.30 / 516 /25;

-- Average delivery rate --
SELECT ROUND(AVG(DATEDIFF(order_delivered_customer_date,order_purchase_timestamp)), 2) AS Delivery_rate
FROM orders;

-- delivered oreders vs. delayed orders --
SELECT COUNT(DISTINCT order_id),
CASE WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0 THEN 'Delayed'
	ELSE 'On time'
    END AS Delivery_status
FROM orders
WHERE order_status = 'delivered' 
AND order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL
GROUP BY Delivery_status;

-- Order review vs. quantity of orders --
SELECT g.state, ROUND(AVG(odr.review_score),1) AS Review_avg_score, COUNT(oi.order_id) AS Qty_orders
FROM geo AS g
LEFT JOIN sellers AS s
ON g.zip_code_prefix = s.seller_zip_code_prefix
LEFT JOIN order_items AS oi
ON s.seller_id = oi.seller_id
LEFT JOIN order_reviews AS odr
ON oi.order_id = odr.order_id
WHERE state IS NOT NULL
GROUP BY state
ORDER BY state;

-- Order review vs. quantity of orders updated --
SELECT g.state, 
       ROUND(AVG(odr.review_score),1) AS Review_avg_score, 
       COUNT(oi.order_id) AS Qty_orders
FROM geo AS g
LEFT JOIN sellers AS s
ON g.zip_code_prefix = s.seller_zip_code_prefix
LEFT JOIN order_items AS oi
ON s.seller_id = oi.seller_id
LEFT JOIN order_reviews AS odr
ON oi.order_id = odr.order_id
LEFT JOIN orders AS o
ON oi.order_id = o.order_id
WHERE g.state IS NOT NULL 
  AND o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY g.state
ORDER BY g.state;