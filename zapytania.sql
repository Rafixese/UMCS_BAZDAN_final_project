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

-- Aktywne umowy dzisiejszego dnia
SELECT contract_type, signed_date, expires_date, salary, job_title  FROM contracts
WHERE expires_date is NULL OR SYSDATE - expires_date < 0;

-- Pracownicy dzia³u napraw komputerów osobistych (podlegaj¹ kierownikowi tego dzia³u)
SELECT first_name, last_name FROM employees
WHERE manager_id = 2;

-- Niezakoñczone us³ugi
SELECT service_type, employee_id, customer_id, created_at, status, customer_description, service_description FROM services
WHERE status != 10;

-- Naprawy hardware
SELECT service_type, employee_id, customer_id, created_at, status, customer_description, service_description FROM services
WHERE service_type = 3;

-- Us³ugi które przesz³y fazê serwisu a nie maj¹ uzupe³nionej notatki serwisowej
SELECT service_type, employee_id, customer_id, created_at, status, customer_description FROM services
WHERE service_description IS NULL;

-- Sumaryczna wycena dla danych us³ug
SELECT service_id, SUM(value) AS pricing_sum FROM pricings
GROUP BY service_id
ORDER BY service_id;

-- Sumaryczny koszt zamówieñ dla danej us³ugi
SELECT service_id, SUM(quantity * unit_price) AS item_orders_sum FROM item_orders
GROUP BY service_id
ORDER BY service_id;

-- Lista czêœci dla danego zamówienia
SELECT product_name, quantity, unit_price FROM item_orders
WHERE service_id = 7;

-- Us³ugi wykonane przez dzia³ napraw komputerów osobistych
SELECT service_type, employee_id, customer_id, created_at, status, customer_description, service_description FROM services
WHERE employee_id IN
(
    SELECT employees.id FROM employees WHERE employees.manager_id = 2
);

-- Pracownicy p³ci ¿eñskiej
SELECT first_name, last_name FROM employees
WHERE sex = 'K';

/*
    Zapytania ³¹cz¹ce (JOIN) dwie tabele
*/

-- Pensje pracowników
SELECT employees.first_name, employees.last_name, contracts.salary
FROM employees INNER JOIN contracts ON employees.contract_id = contracts.id
WHERE contracts.expires_date IS NULL OR SYSDATE - contracts.expires_date < 0;

-- Stanowiska pracowników
SELECT employees.first_name, employees.last_name, contracts.job_title
FROM employees INNER JOIN contracts ON employees.contract_id = contracts.id;

-- Pracownicy zarabiaj¹cy powy¿ej œredniej w firmie
SELECT employees.first_name, employees.last_name, contracts.job_title, contracts.salary
FROM employees INNER JOIN contracts ON employees.contract_id = contracts.id
WHERE (contracts.expires_date IS NULL OR SYSDATE - contracts.expires_date < 0)
    AND contracts.salary > (SELECT AVG(contracts.salary) FROM contracts);
    
-- Pracownicy zarabiaj¹cy poni¿ej œredniej w firmie
SELECT employees.first_name, employees.last_name, contracts.job_title, contracts.salary
FROM employees INNER JOIN contracts ON employees.contract_id = contracts.id
WHERE (contracts.expires_date IS NULL OR SYSDATE - contracts.expires_date < 0)
    AND contracts.salary < (SELECT AVG(contracts.salary) FROM contracts);
    
-- Liczba us³ug danego typu
SELECT service_types.id, service_types.name, COUNT(services.id) AS services_count
FROM service_types LEFT JOIN services ON service_types.id = services.service_type
GROUP BY service_types.id, service_types.name
ORDER BY service_types.id;

-- W jakim stanie znajduje siê konkretna us³uga
SELECT services.id, status_types.name 
FROM services INNER JOIN status_types ON services.status = status_types.id
WHERE services.id = 10;

-- Us³ugi przypisane do konkretnego pracownika (wyszukiwanie po imieniu i nazwisku)
SELECT services.id, services.customer_description, services.service_description, services.status, services.service_type
FROM services INNER JOIN employees ON services.employee_id = employees.id
WHERE employees.first_name LIKE 'Ashley' AND employees.last_name LIKE 'Rice'
ORDER BY services.id;

-- Zlecenie danego klienta (wyszukiwanie po imieniu i nazwisku)
SELECT services.id, services.customer_description, services.service_description, services.status, services.service_type
FROM services INNER JOIN customers ON services.customer_id = customers.id
WHERE customers.first_name LIKE 'Eleanor' AND customers.last_name LIKE 'Dixon'
ORDER BY services.id;

-- Liczba us³ug wykonywanych przez konkretnych pracowników
SELECT employees.first_name, employees.last_name, COUNT(services.id) AS number_of_services
FROM employees LEFT JOIN services ON employees.id = services.employee_id
GROUP BY employees.first_name, employees.last_name
ORDER BY number_of_services DESC;

-- Liczba us³ug o danym statusie
SELECT status_types.name, COUNT(services.id) AS number_of_services
FROM status_types LEFT JOIN services ON services.status = status_types.id
GROUP BY status_types.name
ORDER BY number_of_services DESC;

/*
    Zapytania ³¹cz¹ce (JOIN) trzy tabele
*/

-- Typ umowy i stanowisko dla ka¿dego pracownika (dla aktualnie posiadaj¹cych umowê)
SELECT employees.first_name, employees.last_name, contracts.job_title, contract_types.contract_name
FROM employees 
INNER JOIN contracts ON employees.contract_id = contracts.id 
INNER JOIN contract_types ON contracts.contract_type = contract_types.id
WHERE contracts.expires_date is NULL OR SYSDATE - contracts.expires_date < 0;



