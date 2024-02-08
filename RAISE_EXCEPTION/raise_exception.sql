CREATE OR REPLACE FUNCTION check_salary_with_exception(
	salary real,
	max_salary real DEFAULT 80,
	min_salary real DEFAULT 30,
	index_salary real DEFAULT 0.2) RETURNS bool AS $$
BEGIN
	IF min_salary > max_salary THEN
		RAISE EXCEPTION 'Invalid maximum and minimum salary values'
		USING HINT='The minimum salary cannot be greater than the maximum salary',
		ERRCODE = 12456;
	ELSIF max_salary < 0 OR min_salary < 0 THEN
		RAISE EXCEPTION 'Invalid maximum or minimum salary values'
		USING HINT='Value salary cannot be less than 0',
		ERRCODE = 12457;
	ELSIF index_salary < 0.05 THEN
		RAISE EXCEPTION 'Invalid index salary value'
		USING HINT='Index salary value cannot be less than 0.05',
		ERRCODE = 12458;
	END IF;
	
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
SELECT check_salary_with_exception(79, 10, 80, 0.2)
SELECT check_salary_with_exception(79, 10, -1, 0.2)
SELECT check_salary_with_exception(79, 10, 10, 0.04)


-- сторонняя функция, вызывающая check_salary_with_exception, может обработать все ошибки и выполниться дальше
CREATE OR REPLACE FUNCTION check_salary_with_exception_caller(
	salary real,
	max_salary real,
	min_salary real,
	index_salary real) RETURNS bool AS $$
DECLARE
	err_ctx text;
	err_msg text;
	err_code text;
BEGIN
	RETURN check_salary_with_exception(salary, max_salary, min_salary, index_salary);
EXCEPTION
WHEN SQLSTATE '12456' THEN
	GET STACKED DIAGNOSTICS
		err_ctx = PG_EXCEPTION_CONTEXT,
		err_msg = MESSAGE_TEXT,
		err_code = RETURNED_SQLSTATE;
	RAISE INFO 'My custom handler:';
	RAISE INFO 'Error msg:%', err_msg;
	RAISE INFO 'Error code:%', err_code;
	RAISE INFO 'Error context:%', err_ctx;
	RETURN NULL;
WHEN SQLSTATE '12457' THEN
	GET STACKED DIAGNOSTICS
		err_ctx = PG_EXCEPTION_CONTEXT,
		err_msg = MESSAGE_TEXT,
		err_code = RETURNED_SQLSTATE;
	RAISE INFO 'My custom handler:';
	RAISE INFO 'Error msg:%', err_msg;
	RAISE INFO 'Error code:%', err_code;
	RAISE INFO 'Error context:%', err_ctx;
	RETURN NULL;
WHEN SQLSTATE '12458' THEN
	GET STACKED DIAGNOSTICS
		err_ctx = PG_EXCEPTION_CONTEXT,
		err_msg = MESSAGE_TEXT,
		err_code = RETURNED_SQLSTATE;
	RAISE INFO 'My custom handler:';
	RAISE INFO 'Error msg:%', err_msg;
	RAISE INFO 'Error code:%', err_code;
	RAISE INFO 'Error context:%', err_ctx;
	RETURN NULL;
WHEN OTHERS THEN
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- проверка
SELECT check_salary_with_exception_caller(79, 10, 80, 0.2)
SELECT check_salary_with_exception_caller(79, 10, -1, 0.2)
SELECT check_salary_with_exception_caller(79, 10, 10, 0.04)
