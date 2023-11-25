ALTER TABLE products
ADD CONSTRAINT CHK_products_unit_price CHECK(unit_price > 0)
