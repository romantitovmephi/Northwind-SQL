--1
CREATE VIEW info_order AS
SELECT order_date, required_date, shipped_date, ship_postal_code, company_name, contact_name,
phone, last_name, first_name, title
FROM orders
JOIN customers USING(customer_id)
JOIN employees USING(employee_id)

SELECT *
FROM info_order
WHERE order_date > '1997-01-01'

--2
CREATE OR REPLACE VIEW info_order_exten AS
SELECT order_date, required_date, shipped_date, ship_postal_code, company_name,
contact_name, phone, last_name, first_name, title,
ship_country, employees.postal_code, employees.reports_to
FROM employees
JOIN orders USING(employee_id)
JOIN customers USING(customer_id)

ALTER VIEW info_order_exten RENAME TO info_order_exten_old

SELECT *
FROM info_order_exten
ORDER BY ship_country

DROP VIEW info_order_exten_old

--3
CREATE VIEW active_products AS
SELECT *
FROM products
WHERE discontinued = 0
WITH LOCAL CHECK OPTION

SELECT *
FROM active_products

INSERT INTO active_products
VALUES(123, 'Gantefa', 3, 5, '56 - fkg', 456, 7, 67, 545, 1)
