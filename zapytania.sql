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

-- Aktywne umowy dzisiejszego dnia
SELECT contract_type, signed_date, expires_date, salary, job_title  FROM contracts
WHERE expires_date is NULL OR SYSDATE - expires_date < 0;

-- Pracownicy dzia�u napraw komputer�w osobistych (podlegaj� kierownikowi tego dzia�u)
SELECT first_name, last_name FROM employees
WHERE manager_id = 2;

-- Niezako�czone us�ugi
SELECT service_type, employee_id, customer_id, created_at, status, customer_description, service_description FROM services
WHERE status != 10;

-- Naprawy hardware
SELECT service_type, employee_id, customer_id, created_at, status, customer_description, service_description FROM services
WHERE service_type = 3;

-- Us�ugi kt�re przesz�y faz� serwisu a nie maj� uzupe�nionej notatki serwisowej
SELECT service_type, employee_id, customer_id, created_at, status, customer_description FROM services
WHERE service_description IS NULL;

-- Sumaryczna wycena dla danych us�ug
SELECT service_id, SUM(value) AS pricing_sum FROM pricings
GROUP BY service_id
ORDER BY service_id;

-- Sumaryczny koszt zam�wie� dla danej us�ugi
SELECT service_id, SUM(quantity * unit_price) AS item_orders_sum FROM item_orders
GROUP BY service_id
ORDER BY service_id;

-- Lista cz�ci dla danego zam�wienia
SELECT product_name, quantity, unit_price FROM item_orders
WHERE service_id = 7;

-- Us�ugi wykonane przez dzia� napraw komputer�w osobistych
SELECT service_type, employee_id, customer_id, created_at, status, customer_description, service_description FROM services
WHERE employee_id IN
(
    SELECT employees.id FROM employees WHERE employees.manager_id = 2
);

-- Pracownicy p�ci �e�skiej
SELECT first_name, last_name FROM employees
WHERE sex = 'K';

/*
    Zapytania ��cz�ce (JOIN) dwie tabele
*/

-- Pensje pracownik�w
SELECT employees.first_name, employees.last_name, contracts.salary
FROM employees INNER JOIN contracts ON employees.contract_id = contracts.id
WHERE contracts.expires_date IS NULL OR SYSDATE - contracts.expires_date < 0;

-- Stanowiska pracownik�w
SELECT employees.first_name, employees.last_name, contracts.job_title
FROM employees INNER JOIN contracts ON employees.contract_id = contracts.id;

-- Pracownicy zarabiaj�cy powy�ej �redniej w firmie
SELECT employees.first_name, employees.last_name, contracts.job_title, contracts.salary
FROM employees INNER JOIN contracts ON employees.contract_id = contracts.id
WHERE (contracts.expires_date IS NULL OR SYSDATE - contracts.expires_date < 0)
    AND contracts.salary > (SELECT AVG(contracts.salary) FROM contracts);
    
-- Pracownicy zarabiaj�cy poni�ej �redniej w firmie
SELECT employees.first_name, employees.last_name, contracts.job_title, contracts.salary
FROM employees INNER JOIN contracts ON employees.contract_id = contracts.id
WHERE (contracts.expires_date IS NULL OR SYSDATE - contracts.expires_date < 0)
    AND contracts.salary < (SELECT AVG(contracts.salary) FROM contracts);
    
-- Liczba us�ug danego typu
SELECT service_types.id, service_types.name, COUNT(services.id) AS services_count
FROM service_types LEFT JOIN services ON service_types.id = services.service_type
GROUP BY service_types.id, service_types.name
ORDER BY service_types.id;

