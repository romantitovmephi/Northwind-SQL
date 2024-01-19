--1
SELECT DISTINCT product_name, units_in_stock
FROM products
JOIN order_details USING(product_id)
WHERE units_in_stock < ALL (SELECT AVG(quantity)
			    FROM order_details
			    GROUP BY product_id)
ORDER BY units_in_stock DESC

--2 
SELECT customer_id, SUM(freight) AS freight_sum
FROM orders
JOIN (SELECT customer_id, AVG(freight) AS freight_avg
      FROM orders
      GROUP BY customer_id) oa
USING(customer_id)
WHERE freight > freight_avg AND shipped_date BETWEEN '1996-07-16' AND '1996-07-31'
GROUP BY customer_id
ORDER BY freight_sum 

--3 
SELECT customer_id, ship_country, order_price
FROM orders
JOIN (SELECT order_id, SUM(unit_price * quantity * (1 - discount)) AS order_price
      FROM order_details
      GROUP BY order_id) AS od
USING(order_id)
WHERE ship_country IN ('Argentina', 'Venezuela', 'Mexico', 'Brazil', 'Bolivia', 'Chile', 'Colombia', 'Ecuador', 'Guyana') AND order_date >= '1997-09-01'
ORDER BY order_price DESC
LIMIT 3

--4
SELECT DISTINCT product_name
FROM products
JOIN order_details USING(product_id)
WHERE quantity = 10
