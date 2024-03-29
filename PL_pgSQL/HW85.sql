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
CREATE OR REPLACE FUNCTION avg_freight() RETURNS float8 AS $$
	SELECT AVG(freight)
	FROM orders
$$ LANGUAGE SQL

SELECT avg_freight()

-- 3 
CREATE OR REPLACE FUNCTION get_random_number(left_border int, right_border int) RETURNS int AS $$
	SELECT floor((right_border - left_border + 1) * random() + left_border) 
$$ LANGUAGE SQL

SELECT get_random_number(1, 5) AS random_number

-- 4
-- в моей таблице нет salary
-- добавляем столбец
ALTER TABLE employees
ADD COLUMN salary real

-- добавляем рандомные значения salary через UPDATE столбца в таблице employees
UPDATE employees
SET salary = floor(random()*((5000 - 500) + 1) + 500)
WHERE salary IS NOT NULL -- изначально salary IS NULL везде

-- сама функция		
CREATE OR REPLACE FUNCTION get_salary_employees_by_city(city varchar, OUT min_salary real, OUT max_salary real) AS $$
	SELECT MIN(salary), MAX(salary)
	FROM employees
	WHERE city = city
$$ LANGUAGE SQL

SELECT *
FROM get_salary_employees_by_city('London')

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
DROP FUNCTION correct_salary
		
CREATE OR REPLACE FUNCTION correct_salary(min_salary real DEFAULT 2500, per_correct real DEFAULT 0.15) RETURNS SETOF employees AS $$
	UPDATE employees
	SET salary = salary + (salary * per_correct)
	WHERE salary <= min_salary
	RETURNING * -- чтобы вернуть все измененные записи
$$ LANGUAGE SQL

SELECT * 
FROM correct_salary()

-- 7
DROP FUNCTION correct_salary
		
CREATE OR REPLACE FUNCTION correct_salary(min_salary real DEFAULT 2500, per_correct real DEFAULT 0.15) 
RETURNS TABLE (last_name varchar, first_name varchar, title varchar, salary real) AS $$
	UPDATE employees
	SET salary = salary + (salary * per_correct)
	WHERE salary <= min_salary
	RETURNING last_name, first_name, title, salary
$$ LANGUAGE SQL

SELECT * 
FROM correct_salary()

-- 8
CREATE OR REPLACE FUNCTION orders_by_ship_method(ship_method int) RETURNS SETOF orders AS $$
DECLARE
	max_freight real;
	avg_freight real;
	avg_max_and_avg_freight real;
BEGIN
	SELECT MAX(freight), AVG(freight)
	INTO max_freight, avg_freight
	FROM orders
	WHERE ship_via = ship_method;

	max_freight = 0.7 * max_freight;
	avg_max_and_avg_freight = (max_freight + avg_freight) / 2;
	
	RETURN QUERY
	SELECT * 
	FROM orders
	WHERE freight < avg_max_and_avg_freight; 
END;
$$ LANGUAGE plpgsql;

SELECT COUNT(*) FROM orders_by_ship_method(1)
	
-- 9
CREATE OR REPLACE FUNCTION check_salary_level(
	salary real,
	max_salary real DEFAULT 80,
	min_salary real DEFAULT 30,
	index_salary real DEFAULT 0.2) RETURNS bool AS $$
BEGIN	
	IF salary >= min_salary THEN
		RETURN false;
	ELSE 
		salary = salary * (1 + index_salary);
			IF salary > max_salary THEN
				RETURN false;
			ELSE
				RETURN true;
			END IF;
	END IF;	
END;
$$ LANGUAGE plpgsql;

-- проверка
SELECT check_salary_with_exception(40, 80, 30, 0.2)
SELECT check_salary_with_exception(79, 81, 80, 0.2)
SELECT check_salary_with_exception(79, 95, 80, 0.2)

