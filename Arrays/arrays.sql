-- 1
CREATE OR REPLACE FUNCTION avg_freight_by_countries(VARIADIC countries varchar[]) RETURNS real AS $$
	SELECT AVG(freight)
	FROM orders
	WHERE ship_country = ANY(countries)
$$ LANGUAGE SQL

SELECT * FROM avg_freight_by_countries('France', 'Belgium')

-- проверка
SELECT AVG(freight)
FROM orders
WHERE ship_country IN ('France', 'Belgium')

-- 2
CREATE OR REPLACE FUNCTION filter_by_phone_number(operator_code int, VARIADIC phones varchar[]) RETURNS SETOF varchar AS $$
DECLARE
	pointer varchar;
BEGIN
	FOREACH pointer IN ARRAY(phones)
	LOOP
		CONTINUE WHEN pointer NOT LIKE CONCAT('__(', operator_code, ')%');
		RETURN NEXT pointer;
	END LOOP;
END
$$ LANGUAGE plpgsql;

SELECT * FROM filter_by_phone_number(903, '+7(903)1901235', '+7(926)8567589', '+7(903)1532476')
SELECT * FROM filter_by_phone_number(903, VARIADIC ARRAY['+7(903)1901235', '+7(926)8567589', '+7(903)1532476'])