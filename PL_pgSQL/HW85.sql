-- 1
CREATE OR REPLACE FUNCTION backup_customers() RETURNS void AS $$
	DROP TABLE IF EXISTS backup_customers;
	
	CREATE TABLE backup_customers AS
	SELECT *
	FROM customers
$$ LANGUAGE SQL

-- вызов функции
SELECT backup_customers() 

SELECT COUNT(*)
FROM backup_customers

-- 2
CREATE OR REPLACE FUNCTION avg_freight() RETURNS real AS $$
	SELECT AVG(freight)
	FROM orders
$$ LANGUAGE SQL

-- 3 
CREATE OR REPLACE FUNCTION get_rand_num(lower_bound int, upper_bound int) RETURNS int AS $$
	SELECT floor(random()*((upper_bound - lower_bound) + 1) + lower_bound)
$$ LANGUAGE SQL

SELECT get_rand_num(1, 3)
FROM generate_series(1, 5) -- показал автор

-- 4

-- когда есть OUT параметры, то RETURNS не нужен
-- в моей таблице нет salary
-- добавляем столбец
ALTER TABLE employees
ADD COLUMN salary int

-- поменяем тип столбца salary
ALTER TABLE employees
ALTER COLUMN salary SET DATA TYPE real

-- так добавить значения не получается, 
-- потому что есть огран-я по другим столбцам?
INSERT INTO employees(salary)
VALUES 
('475'),
('5686'),
('456'),
('56'),
('47565'),
('53686'),
('48956'),
('516'),
('5');

-- добавляем рандомные значения salary через UPDATE столбца в таблице employees
UPDATE employees
SET salary = floor(random()*((5000 - 500) + 1) + 500)
WHERE salary IS NOT NULL -- изначально salary IS NULL везде

SELECT salary
FROM employees

-- сама функция
CREATE OR REPLACE FUNCTION get_employee_salary(employee_city varchar, OUT min_salary int, OUT max_salary int) AS $$
	SELECT MIN(salary), MAX(salary)
	FROM employees
	WHERE city = employee_city
$$ LANGUAGE SQL

-- если со * он выдаст все выходные параметры
SELECT * 
FROM get_employee_salary('London') 
-- а так только один кортеж
SELECT get_employee_salary('London')

SELECT * 
FROM employees
WHERE city = 'London'

-- 5
DROP FUNCTION correct_salary()
-- чтобы увидеть работу функции, нужно проапдейтить столбец salary подходящими значениями
--функция ничего не возвращает, она апдейтит в таблице employees столбец salary, поэтому RETURNS void
CREATE OR REPLACE FUNCTION correct_salary(min_salary real DEFAULT 2500, per_correct real DEFAULT 0.15) RETURNS void AS $$
	UPDATE employees
	SET salary = salary + (salary * per_correct)
	WHERE salary <= min_salary
$$ LANGUAGE SQL

SELECT correct_salary()

SELECT salary 
FROM employees
ORDER BY salary

-- 6
--DROP FUNCTION correct_salary_2
CREATE OR REPLACE FUNCTION correct_salary_2(min_salary real DEFAULT 2500, per_correct real DEFAULT 0.15) RETURNS SETOF employees AS $$
	UPDATE employees
	SET salary = salary + (salary * per_correct)
	WHERE salary <= min_salary
	RETURNING * -- чтобы вернуть все измененные записи
$$ LANGUAGE SQL

SELECT * 
FROM correct_salary_2()

-- 7
DROP FUNCTION correct_salary_3
CREATE OR REPLACE FUNCTION correct_salary_3(min_salary real DEFAULT 2500, per_correct real DEFAULT 0.15) 
RETURNS TABLE (last_name varchar, first_name varchar, title varchar, salary real) AS $$
	UPDATE employees
	SET salary = salary + (salary * per_correct)
	WHERE salary <= min_salary
	RETURNING last_name, first_name, title, salary
$$ LANGUAGE SQL

SELECT * 
FROM correct_salary_3()

-- 8
DROP FUNCTION check_shipping(integer)
-- функция проверена и правильно работает
CREATE OR REPLACE FUNCTION check_shipping(ship_method int) RETURNS SETOF orders AS $$
DECLARE
	max_freight_ship_method real;
	correct_max_freight_ship_method real;
	avg_freight_ship_method real;
	avg_avg_freight real;
BEGIN
	SELECT MAX(freight) INTO max_freight_ship_method
	FROM orders
	WHERE ship_via = ship_method;
	--RETURN max_freight_ship_method; --для проверки
	
	correct_max_freight_ship_method = max_freight_ship_method * 0.7; 
	--RETURN correct_max_freight_ship_method; 
	--ЗАМЕЧАНИЕ: если записать RETURN correct_max_freight_ship_method = max_freight_ship_method * 0.7;
	--вернется NULL, тк значение еще не будет вычислено
	
	SELECT AVG(freight) INTO avg_freight_ship_method
	FROM orders
	WHERE ship_via = ship_method;
	--RETURN avg_freight_ship_method;
	
	avg_avg_freight = (correct_max_freight_ship_method + avg_freight_ship_method) / 2;
	--RETURN avg_avg_freight;
	--AVG здесь НЕ РАБОТАЕТ, надо брать ср. ариф-ое /2

	RETURN QUERY 
	SELECT *
	FROM orders
	WHERE freight < avg_avg_freight AND ship_via = ship_method -- логично дописать условие
	--GROUP BY order_id
	--HAVING ship_via = ship_method; 
	ORDER BY freight DESC;

END;
$$ LANGUAGE plpgsql;


SELECT *
FROM orders

SELECT *
FROM check_shipping(1)

-- 9
CREATE OR REPLACE FUNCTION check_salary(c int, max int DEFAULT 80, min int DEFAULT 30, r real DEFAULT 0.2) RETURNS bool AS $$
BEGIN
	IF c >= min THEN
		RETURN false;
	ELSE 
		c = c * (1 + r);
			IF c > max THEN
				RETURN false;
			ELSE
				RETURN true;
			END IF;
	END IF;
	
END;
$$ LANGUAGE plpgsql;

SELECT check_salary(79, 95, 80, 0.2)

