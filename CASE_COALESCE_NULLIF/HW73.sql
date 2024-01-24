INSERT INTO customers(customer_id, contact_name, city, country, company_name)
VALUES 
('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
('BBBBB', 'Alfred Mann', NULL, 'Austria','fake_company');

--1
SELECT contact_name, city, country
FROM customers
ORDER BY contact_name, COALESCE(city, country)

--2
SELECT product_name, unit_price, 
	CASE WHEN unit_price >= 100 THEN 'too expensive'
	     WHEN unit_price >= 50 AND unit_price < 100 THEN 'average'
	     ELSE 'low price'
	END AS amount
FROM products
ORDER BY unit_price DESC

--3
SELECT customer_id, COALESCE(TO_CHAR(order_id, 'FM99999999'), 'no orders') AS order_status
FROM customers
LEFT JOIN orders USING(customer_id)
WHERE order_id IS NULL

--4
SELECT first_name, last_name, COALESCE(NULLIF(title, 'Sales Representative'), 'Sales Stuff') AS title
FROM employees
