-- 1
ALTER TABLE products
ADD COLUMN last_updated timestamp;

CREATE OR REPLACE FUNCTION track_changes_on_products() RETURNS trigger AS $$
BEGIN
	NEW.last_updated = now();  -- запишем текущее время
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER products_timestamp BEFORE INSERT OR UPDATE ON products
	FOR EACH ROW EXECUTE PROCEDURE track_changes_on_products();
	
-- проверка	
SELECT *
FROM products

INSERT INTO products
VALUES(81, 'Cheburek', 12, 2, '', 45, 1, 2, 3, 0)

UPDATE products
SET unit_price = 50
WHERE product_name = 'Tofu'

-- увидим время изменения в last_updated
SELECT *
FROM products
WHERE product_id = 81 OR product_name = 'Tofu'

-- 2
DROP TABLE IF EXISTS order_details_audit;

CREATE TABLE order_details_audit
(
	operation char(1) NOT NULL,
	user_changed text NOT NULL,
	time_stamp timestamp NOT NULL,
	
	order_id smallint NOT NULL,
	product_id smallint NOT NULL,
	unit_price real NOT NULL,
	quantity smallint NOT NULL,
	discount real NOT NULL	
);

CREATE OR REPLACE FUNCTION build_order_details_audit() RETURNS trigger AS $$
BEGIN
	IF TG_OP = 'INSERT' THEN
		INSERT INTO order_details_audit
		SELECT 'I', session_user, now(), nt.* FROM new_table nt;
	ELSEIF TG_OP = 'UPDATE' THEN
		INSERT INTO order_details_audit
		SELECT 'U', session_user, now(), nt.* FROM new_table nt;
	ELSEIF TG_OP = 'DELETE' THEN
		INSERT INTO order_details_audit
		SELECT 'D', session_user, now(), ot.* FROM old_table ot;
	END IF;
	RETURN NULL;
END
$$ LANGUAGE plpgsql;

-- создаем триггеры
CREATE TRIGGER audit_order_details_insert AFTER INSERT ON order_details
REFERENCING NEW TABLE AS new_table
FOR EACH STATEMENT EXECUTE PROCEDURE build_order_details_audit();

CREATE TRIGGER audit_order_details_update AFTER UPDATE ON order_details
REFERENCING NEW TABLE AS new_table
FOR EACH STATEMENT EXECUTE PROCEDURE build_order_details_audit();

CREATE TRIGGER audit_order_details_delete AFTER DELETE ON order_details
REFERENCING OLD TABLE AS old_table
FOR EACH STATEMENT EXECUTE PROCEDURE build_order_details_audit();

-- проверка
SELECT *
FROM order_details
ORDER BY order_id DESC;

INSERT INTO order_details
VALUES (11077, 80, 15, 5, 0);

SELECT * 
FROM order_details_audit;

UPDATE order_details
SET unit_price = 25
WHERE order_id = 11077 AND product_id = 80;

DELETE 
FROM order_details
WHERE order_id = 11077 AND product_id = 80;

SELECT * 
FROM order_details_audit;