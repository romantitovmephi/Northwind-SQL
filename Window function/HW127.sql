--1
--к каждому employee_id привязаны order_id
--подзапрос считает сумму всех заказов и РАЗДЕЛЯЕТ по employee_id (PARTITION BY employee_id)
--DISTINCT employee_id - иначе он будет дублировать все заказы каждого сотрудника
--подзапрос:
	SELECT DISTINCT employee_id, first_name, last_name, salary,
	SUM(unit_price*quantity) OVER (PARTITION BY employee_id) AS total_sales_employee
	FROM orders
	LEFT JOIN order_details USING(order_id)
	JOIN employees USING(employee_id)
	ORDER BY total_sales_employee DESC


--сам запрос
SELECT DISTINCT employee_id, first_name, last_name, salary, total_sales_employee, 
AVG(total_sales_employee) OVER() AS avg_sales -- оконная функция AVG - окно тут - все строки результата запроса, нет какой-то категории (PARTITION)
FROM (
	SELECT DISTINCT employee_id, first_name, last_name, salary,
	SUM(unit_price*quantity) OVER (PARTITION BY employee_id) AS total_sales_employee
	FROM orders
	LEFT JOIN order_details USING(order_id)
	JOIN employees USING(employee_id)
	ORDER BY total_sales_employee DESC
) subquery
ORDER BY total_sales_employee DESC



--2
SELECT first_name, last_name, title, salary,
	DENSE_RANK() OVER(ORDER BY salary) AS ranking
FROM employees