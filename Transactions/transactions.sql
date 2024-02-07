-- 1
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- CTE нужно выделять и использовать вместе с дальнейшим SELECT * INTO archive_customers
WITH small_price_customers AS (           
	SELECT customer_id, SUM(unit_price * quantity) AS price_orders
	FROM orders
	JOIN order_details USING(order_id)
	GROUP BY customer_id
	HAVING SUM(unit_price * quantity) < 5000  -- таких 17
	ORDER BY price_orders
)
SELECT * INTO customers_to_archive
FROM orders
WHERE customer_id IN (SELECT customer_id FROM small_price_customers);

-- проверка
/*
SELECT * FROM customers_to_archive

SELECT COUNT(DISTINCT(customer_id)) FROM customers_to_archive   -- 17

SELECT COUNT(customer_id)
FROM customers   -- 77      
*/

-- если оставить SAVEPOINT backup и ROLLBACK TO backup, то строки из таблиц удаляться не будут
SAVEPOINT backup; 

-- удаляем инфо из связных таблиц
DELETE
FROM order_details
WHERE order_id IN (SELECT order_id FROM customers_to_archive);

DELETE
FROM orders
WHERE order_id IN (SELECT order_id FROM customers_to_archive);

DELETE
FROM customers
WHERE customer_id IN (SELECT customer_id FROM customers_to_archive);

-- проверка
/*
SELECT COUNT(customer_id)
FROM customers            -- 60 = 77-17
*/
ROLLBACK TO backup;

COMMIT;

--DROP TABLE IF EXISTS customers_to_archive;

-- 2
BEGIN;
WITH products_discontinued AS(
	SELECT product_id
	FROM products
	WHERE discontinued = 1  -- таких 10
)
SELECT * INTO products_discontinued_archive
FROM products
WHERE product_id IN (SELECT product_id FROM products_discontinued);

-- проверка
/*
SELECT * FROM products_discontinued_archive

SELECT COUNT(product_id)
FROM products          -- 81
*/

SAVEPOINT backup;

DELETE 
FROM order_details
WHERE product_id IN (SELECT product_id FROM products_discontinued_archive);

DELETE
FROM products
WHERE product_id IN (SELECT product_id FROM products_discontinued_archive);

/*
SELECT COUNT(product_id)
FROM products          -- 71
*/

ROLLBACK TO backup;

COMMIT;

--SELECT * FROM products

--DROP TABLE products_discontinued_archive