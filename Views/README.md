

1. Создать представление, которое выводит следующие колонки:

order_date, required_date, shipped_date, ship_postal_code, company_name, contact_name, phone, last_name, first_name, title из таблиц orders, customers и employees.

Сделать select к созданному представлению, выведя все записи, где order_date больше 1го января 1997 года.

2. Создать представление, которое выводит следующие колонки:

order_date, required_date, shipped_date, ship_postal_code, ship_country, company_name, contact_name, phone, last_name, first_name, title из таблиц orders, customers, employees.

Попробовать добавить к представлению (после его создания) колонки ship_country, postal_code и reports_to. Убедиться, что проихсодит ошибка. Переименовать представление и создать новое уже с дополнительными колонками.

Сделать к нему запрос, выбрав все записи, отсортировав их по ship_county.

Удалить переименованное представление.

3.  Создать представление "активных" (discontinued = 0) продуктов, содержащее все колонки. Представление должно быть защищено от вставки записей, в которых discontinued = 1.

Попробовать сделать вставку записи с полем discontinued = 1 - убедиться, что не проходит.