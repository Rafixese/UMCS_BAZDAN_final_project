/*
    Projekcje
*/

-- Dane osobowe wszyskich pracowników
SELECT first_name, last_name, pesel, phone, email, sex FROM employees;

-- Us³ugi realizowane przez serwis
SELECT name FROM service_types;

-- Dane wszystkich klientów
SELECT first_name, last_name, phone, email FROM customers;

-- Typy statusów us³ug
SELECT name FROM status_types ORDER BY id;

-- Kategorie produktów
SELECT name FROM product_categories;

-- Wszystkie zamówione czêœci do us³ug
SELECT product_name, quantity, unit_price FROM item_orders;

-- Wszystkie wyceny us³ug wraz z opisem
SELECT value, description FROM pricings;

-- Wszystkie serwisy uporz¹dkowane dat¹ zg³oszenia od najnowszych do najstarszych
SELECT created_at, customer_description, service_description FROM services ORDER BY created_at DESC;

-- Typy umów pomiêdzy pracownikami a firm¹
SELECT contract_name FROM contract_types;

-- Umowy z pracownikami
SELECT signed_date, expires_date, salary, job_title FROM contracts ORDER BY signed_date DESC;


/*
    SELEKCJE
*/

