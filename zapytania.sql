/*
    Projekcje
*/

-- Dane osobowe wszyskich pracownik�w
SELECT first_name, last_name, pesel, phone, email, sex FROM employees;

-- Us�ugi realizowane przez serwis
SELECT name FROM service_types;

-- Dane wszystkich klient�w
SELECT first_name, last_name, phone, email FROM customers;

-- Typy status�w us�ug
SELECT name FROM status_types ORDER BY id;

-- Kategorie produkt�w
SELECT name FROM product_categories;

-- Wszystkie zam�wione cz�ci do us�ug
SELECT product_name, quantity, unit_price FROM item_orders;

-- Wszystkie wyceny us�ug wraz z opisem
SELECT value, description FROM pricings;

-- Wszystkie serwisy uporz�dkowane dat� zg�oszenia od najnowszych do najstarszych
SELECT created_at, customer_description, service_description FROM services ORDER BY created_at DESC;

-- Typy um�w pomi�dzy pracownikami a firm�
SELECT contract_name FROM contract_types;

-- Umowy z pracownikami
SELECT signed_date, expires_date, salary, job_title FROM contracts ORDER BY signed_date DESC;


/*
    SELEKCJE
*/

