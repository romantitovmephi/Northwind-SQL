--1
SELECT employee_id, first_name, last_name, sales_amount,
AVG(sales_amount) OVER() AS avg_sales_amount -- окно пустое OVER () - значит окно это все строки результата запроса
FROM (SELECT employee_id, first_name, last_name, SUM(unit_price * quantity) AS sales_amount
      FROM employees
      JOIN orders USING(employee_id)
      JOIN order_details USING(order_id)
      GROUP BY employee_id
      ORDER BY employee_id) subquery -- делаю обычный запрос с суммой продаж каждого сотрудника
ORDER BY sales_amount DESC

--2
SELECT first_name, last_name, title, salary,
	DENSE_RANK() OVER(ORDER BY salary) AS ranking
FROM employees
