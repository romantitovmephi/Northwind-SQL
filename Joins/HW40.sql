--1
SELECT customers.company_name, CONCAT(first_name, ' ', last_name)
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
JOIN employees ON orders.employee_id = employees.employee_id
JOIN shippers ON orders.ship_via = shippers.shipper_id
WHERE customers.city = 'London' AND employees.city = 'London' AND shippers.company_name = 'Speedy Express'

--2
SELECT product_name, units_in_stock, contact_name, phone
FROM products
JOIN categories USING(category_id)
JOIN suppliers USING(supplier_id)
WHERE (category_name = 'Beverages' or category_name = 'Seafood') AND discontinued != 1 AND units_in_stock < 20

--3 ВСЕГО кастомеров 91, но у 2 нет order_id, то есть нет заказов
-- поэтому при order_id IS NULL эти кастомеры отображаются
-- хотя в orders у них нет NULL в order_id (этих кастомеров просто нет)
SELECT company_name, order_id
FROM customers
LEFT JOIN orders USING(customer_id)
WHERE order_id IS NULL

--4 берем всех кастомеров справа, при условии что у них как бы
-- order_id IS NULL(т.е. просто отсутствует)
SELECT company_name, order_id
FROM orders
RIGHT JOIN customers USING(customer_id)
WHERE order_id IS NULL