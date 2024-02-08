Имеется следующая функция

```
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
```
Модифицировать функцию check_salary_level разработанную в секции по функциям таким образом, чтобы запретить (выбрасывая исключения) передачу аргументов так, что:

  минимальный уровень з/п превышает максимальный

  ни минимальный, ни максимальный уровень з/п не могут быть меньше нуля

  коэффициент повышения зарплаты не может быть ниже 5%

Протестировать реализацию, передавая следующие значения аргументов
(с - уровень "проверяемой" зарплаты, r - коэффициент повышения зарплаты):

c = 79, max = 10, min = 80, r = 0.2

c = 79, max = 10, min = -1, r = 0.2

c = 79, max = 10, min = 10, r = 0.04
