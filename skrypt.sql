/*============================================*/
/*  Usuniêcie tabel stworzonych przez skrypt  */
/*============================================*/

DROP TABLE contract_types CASCADE CONSTRAINTS;      -- Usuniêcie tabeli contract_types wraz ze wszystkimi ograniczeniami integralnoœciowymi
DROP TABLE contracts CASCADE CONSTRAINTS;           -- Usuniêcie tabeli contracts wraz ze wszystkimi ograniczeniami integralnoœciowymi
DROP TABLE employees CASCADE CONSTRAINTS;           -- Usuniêcie tabeli employees wraz ze wszystkimi ograniczeniami integralnoœciowymi
DROP TABLE customers CASCADE CONSTRAINTS;           -- Usuniêcie tabeli customers wraz ze wszystkimi ograniczeniami integralnoœciowymi
DROP TABLE service_types CASCADE CONSTRAINTS;       -- Usuniêcie tabeli service_types wraz ze wszystkimi ograniczeniami integralnoœciowymi
DROP TABLE status_types CASCADE CONSTRAINTS;        -- Usuniêcie tabeli status_types wraz ze wszystkimi ograniczeniami integralnoœciowymi
DROP TABLE services CASCADE CONSTRAINTS;            -- Usuniêcie tabeli services wraz ze wszystkimi ograniczeniami integralnoœciowymi
DROP TABLE pricings CASCADE CONSTRAINTS;            -- Usuniêcie tabeli pricings wraz ze wszystkimi ograniczeniami integralnoœciowymi
DROP TABLE product_categories CASCADE CONSTRAINTS;  -- Usuniêcie tabeli product_categories wraz ze wszystkimi ograniczeniami integralnoœciowymi
DROP TABLE item_orders CASCADE CONSTRAINTS;         -- Usuniêcie tabeli item_orders wraz ze wszystkimi ograniczeniami integralnoœciowymi


/*============================================*/
/*           Tworzenie nowych tabel           */
/*============================================*/

/*
    Utworzenie tabeli contract_types
    
    Pola tabeli:
        id              liczba      identyfikator
        contract_name   napis(30)   nazwa rodzaju umowy, np. umowa o pracê,
        
    Ograniczenia integralnoœciowe:
        id              klucz g³ówny
        contract_name   nie mo¿e byæ pusty (NOT NULL),
                        musi byæ unikalny (UNIQUE)
*/
CREATE TABLE contract_types
(
    id              NUMBER,
    contract_name   VARCHAR(50)             NOT NULL,
    
    CONSTRAINT      contract_types_pk       PRIMARY KEY(id),
    CONSTRAINT      contract_types_name_uq  UNIQUE (contract_name)
);

/*
    Utworzenie tabeli contracts
    
    Pola tabeli:
        id              liczba      identyfikator
        contract_type   liczba      identyfikator typu umowy z tabeli contract_types
        signed_date     data        data podpisania umowy
        expires_date    data        data wygaœniêcia umowy
        salary          liczba      wartoœæ wyp³aty
        job_title       napis       nazwa stanowiska
        
    Ograniczenia integralnoœciowe:
        id              klucz g³ówny
        contract_type   klucz obcy,
                        nie mo¿e byæ pusty (NOT NULL)
        signed_date     nie mo¿e byæ pusty (NOT NULL)
        expires_date
        salary          nie mo¿e byæ pusty (NOT NULL)
        job_title       nie mo¿e byæ pusty (NOT NULL)
*/

CREATE TABLE contracts
(
    id              NUMBER,
    contract_type   NUMBER          NOT NULL,
    signed_date     DATE            NOT NULL,
    expires_date    DATE            NULL,
    salary          NUMBER(7,2)     NOT NULL,
    job_title       VARCHAR(70)     NOT NULL,
    
    CONSTRAINT      contracts_pk    PRIMARY KEY (id),
    CONSTRAINT      contracts_fk1   FOREIGN KEY (contract_type) REFERENCES contract_types (id)
);

/*
    Utworzenie tabeli employees
    
    Pola tabeli:
        id              liczba      identyfikator
        first_name      napis       imiê pracownika
        last_name       napis       nazwisko pracownika
        phone           napis       numer telefonu
        email           napis       adres email
        pesel           napis       nr pesel
        sex             litera      p³eæ: m - mê¿czyzna, k - kobieta
        manager_id      liczba      identyfikator prze³o¿onego, relacja zwrotna do tabeli employees
        contract_id     liczba      identyfikator umowy z tabeli contracts
        
    Ograniczenia integralnoœciowe:
        id              klucz g³ówny
        first_name      nie mo¿e byæ pusty (NOT NULL)
        last_name       nie mo¿e byæ pusty (NOT NULL)
        phone           nie mo¿e byæ pusty (NOT NULL),
                        musi byæ unikalny (UNIQUE)
                        musi sk³adaæ siê tylko z cyfr (CHECK)
        email           nie mo¿e byæ pusty (NOT NULL),
                        musi byæ unikalny (UNIQUE),
                        musi pasowaæ do wyra¿enia regularnego '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'
        pesel           nie mo¿e byæ pusty (NOT NULL),
                        musi byæ unikalny (UNIQUE),
                        musi sk³adaæ siê tylko z cyfr (CHECK)
        sex             nie mo¿e byæ pusty (NOT NULL),
                        musi nale¿eæ do zbioru ('M', 'K') (CHECK)
        manager_id      klucz obcy
        contract_id     klucz obcy
                        nie mo¿e byæ pusty (NOT NULL),
                        musi byæ unikalny (UNIQUE)
*/

CREATE TABLE employees
(
    id              NUMBER,
    first_name      VARCHAR(30)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    phone           VARCHAR(9)      NOT NULL,
    email           VARCHAR(50)     NOT NULL,
    pesel           VARCHAR(11)     NOT NULL,
    sex             CHAR(1)         NOT NULL,
    manager_id      NUMBER,
    contract_id     NUMBER          NOT NULL,
    
    CONSTRAINT employees_pk             PRIMARY KEY (id),
    CONSTRAINT employees_phone_uq       UNIQUE (phone),
    CONSTRAINT employees_phone_chk1     CHECK ( REGEXP_LIKE(phone, '^[0-9]{9}$') ),
    CONSTRAINT employees_email_uq       UNIQUE (email),
    CONSTRAINT employees_email_chk1     CHECK ( REGEXP_LIKE(email, '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') ),
    CONSTRAINT employees_pesel_chk1     CHECK ( REGEXP_LIKE(pesel, '^[0-9]{11}$') ),
    CONSTRAINT employees_sex_chk1       CHECK ( sex IN ('M', 'K') ),
    CONSTRAINT employees_fk1            FOREIGN KEY (manager_id) REFERENCES employees (id),
    CONSTRAINT employees_fk2            FOREIGN KEY (contract_id) REFERENCES contracts (id),
    CONSTRAINT employees_contract_id_uq UNIQUE (contract_id)
);

/*
    Utworzenie tabeli customers
    
    Pola tabeli:
        id              liczba      identyfikator
        first_name      napis       imiê klienta
        last_name       napis       nazwisko klienta
        phone           napis       numer telefonu
        email           napis       adres email
        
    Ograniczenia integralnoœciowe:
        id              klucz g³ówny
        first_name      nie mo¿e byæ pusty (NOT NULL)
        last_name       nie mo¿e byæ pusty (NOT NULL)
        phone           nie mo¿e byæ pusty (NOT NULL),
                        musi byæ unikalny (UNIQUE)
                        musi sk³adaæ siê tylko z cyfr (CHECK)
        email           nie mo¿e byæ pusty (NOT NULL),
                        musi byæ unikalny (UNIQUE),
                        musi pasowaæ do wyra¿enia regularnego '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'
*/

CREATE TABLE customers
(
    id              NUMBER,
    first_name      VARCHAR(30)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    phone           VARCHAR(9)      NOT NULL,
    email           VARCHAR(50)     NOT NULL,
    
    CONSTRAINT customers_pk             PRIMARY KEY (id),
    CONSTRAINT customers_phone_uq       UNIQUE (phone),
    CONSTRAINT customers_phone_chk1     CHECK ( REGEXP_LIKE(phone, '^[0-9]{9}$') ),
    CONSTRAINT customers_email_uq       UNIQUE (email),
    CONSTRAINT customers_email_chk1     CHECK ( REGEXP_LIKE(email, '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') )
);

/*
    Utworzenie tabeli service_types
    
    Pola tabeli:
        id      liczba      identyfikator
        name    napis       nazwa czynnoœci serwisowej
        
    Ograniczenia integralnoœciowe:
        id          klucz g³ówny
        name        nie mo¿e byæ pusty (NOT NULL),
                    musi byæ unikalny (UNIQUE)
*/

CREATE TABLE service_types
(
    id      NUMBER,
    name    VARCHAR(50)     NOT NULL,
    
    CONSTRAINT service_types_pk         PRIMARY KEY (id),
    CONSTRAINT service_types_name_uq    UNIQUE (name)
);

/*
    Utworzenie tabeli status_types
    
    Pola tabeli:
        id      liczba      identyfikator
        name    napis       nazwa statusu
        
    Ograniczenia integralnoœciowe:
        id          klucz g³ówny
        name        nie mo¿e byæ pusty (NOT NULL),
                    musi byæ unikalny (UNIQUE)
*/

CREATE TABLE status_types
(
    id      NUMBER,
    name    VARCHAR(50)     NOT NULL,
    
    CONSTRAINT status_types_pk         PRIMARY KEY (id),
    CONSTRAINT status_types_name_uq    UNIQUE (name)
);

/*
    Utworzenie tabeli services
    
    Pola tabeli:
        id                      liczba      identyfikator
        service_type            liczba      identyfikator typu czynnoœci serwisowej z tabeli service_types
        employee_id             liczba      identyfikator pracownika odpowiedzialnego za dan¹ czynnoœæ serwisow¹
        customer_id             liczba      identyfikator klienta, który zg³osi³ potrzebê serwisu
        created_at              date        data zg³oszenia serwisu
        status                  liczba      identyfikator statusu serwisu z tabeli status_types
        customer_description    napis       opis usterki lub czynnoœci serwisowej do wykonania
        service_description     napis       opis przeprowadzonych czynnoœci przez serwisanta
        
    Ograniczenia integralnoœciowe:
        id                      klucz g³ówny
        service_type            klucz obcy,
                                nie mo¿e byæ pusty (NOT NULL)
        employee_id             klucz obcy,
                                nie mo¿e byæ pusty (NOT NULL)
        customer_id             klucz obcy,
                                nie mo¿e byæ pusty (NOT NULL)
        created_at              nie mo¿e byæ pusty (NOT NULL),
        status                  klucz obcy,
                                nie mo¿e byæ pusty (NOT NULL)
        customer_description    nie mo¿e byæ pusty (NOT NULL)
        service_description     
*/

CREATE TABLE services
(
    id                      NUMBER,
    service_type            NUMBER          NOT NULL,
    employee_id             NUMBER          NOT NULL,
    customer_id             NUMBER          NOT NULL,
    created_at              DATE            NOT NULL,
    status                  NUMBER          NOT NULL,
    customer_description    VARCHAR(4000)   NOT NULL,
    service_description     VARCHAR(4000),
    
    CONSTRAINT services_pk      PRIMARY KEY (id),
    CONSTRAINT services_fk1     FOREIGN KEY (service_type) REFERENCES service_types (id),
    CONSTRAINT services_fk2     FOREIGN KEY (employee_id) REFERENCES employees (id),
    CONSTRAINT services_fk3     FOREIGN KEY (customer_id) REFERENCES customers (id),
    CONSTRAINT services_fk4     FOREIGN KEY (status) REFERENCES status_types (id)
);

/*
    Utworzenie tabeli pricings
    
    Pola tabeli:
        id              liczba      identyfikator
        service_id      liczba      identyfikator serwisu, do którego nale¿y rekord wyceny czynnoœci serwisowej
        value           liczba      cena czynnoœci serwisowej
        description     napis       krótki opis czynnoœci serwisowej
        
    Ograniczenia integralnoœciowe:
        id              klucz g³ówny
        service_id      klucz obcy
                        nie mo¿e byæ pusty (NOT NULL)
        value           nie mo¿e byæ pusty (NOT NULL)
        description     nie mo¿e byæ pusty (NOT NULL)
*/

CREATE TABLE pricings
(
    id              NUMBER,
    service_id      NUMBER          NOT NULL,
    value           NUMBER(7,2)     NOT NULL,
    description     VARCHAR(150)    NOT NULL,
    
    CONSTRAINT pricings_pk      PRIMARY KEY (id),
    CONSTRAINT pricings_fk1     FOREIGN KEY (service_id) REFERENCES services (id)
);

/*
    Utworzenie tabeli product_categories
    
    Pola tabeli:
        id      liczba      identyfikator
        name    napis       nazwa kategorii
        
    Ograniczenia integralnoœciowe:
        id          klucz g³ówny
        name        nie mo¿e byæ pusty (NOT NULL),
                    musi byæ unikalny (UNIQUE)
*/

CREATE TABLE product_categories
(
    id      NUMBER,
    name    VARCHAR(50)     NOT NULL,
    
    CONSTRAINT product_categories_pk         PRIMARY KEY (id),
    CONSTRAINT product_categories_name_uq    UNIQUE (name)
);

/*
    Utworzenie tabeli item_orders
    
    Pola tabeli:
        id                  liczba      identyfikator
        service_id          liczba      identyfikator serwisu, do którego nale¿y rekord zamówienia czêœci
        product_name        napis       nazwa produktu
        product_category    liczba      identyfikator kategorii z tabeli product_categories
        quantity            liczba      liczba sztuk produktu
        unit_price          liczba      cena za sztukê
        
    Ograniczenia integralnoœciowe:
        id                  klucz g³ówny
        service_id          klucz obcy,
                            nie mo¿e byæ pusty (NOT NULL)
        product_name        nie mo¿e byæ pusty (NOT NULL)
        product_category    klucz obcy,
                            nie mo¿e byæ pusty (NOT NULL)
        quantity            nie mo¿e byæ pusty (NOT NULL)
        unit_price          nie mo¿e byæ pusty (NOT NULL)
*/

CREATE TABLE item_orders
(
    id NUMBER,
    service_id          NUMBER          NOT NULL,
    product_name        VARCHAR(150)    NOT NULL,
    product_category    NUMBER          NOT NULL,
    quantity            NUMBER          NOT NULL,
    unit_price          NUMBER          NOT NULL,
    
    CONSTRAINT item_orders_pk       PRIMARY KEY (id),
    CONSTRAINT item_orders_pk_fk1   FOREIGN KEY (service_id) REFERENCES services (id),
    CONSTRAINT item_orders_pk_fk2   FOREIGN KEY (product_category) REFERENCES product_categories (id)
);

/*============================================*/
/*             Usuniêcie sekwencji            */
/*============================================*/

DROP SEQUENCE contract_types_seq;
DROP SEQUENCE contracts_seq;
DROP SEQUENCE employees_seq;
DROP SEQUENCE customers_seq;
DROP SEQUENCE service_types_seq;
DROP SEQUENCE status_types_seq;
DROP SEQUENCE services_seq;
DROP SEQUENCE pricings_seq;
DROP SEQUENCE product_categories_seq;
DROP SEQUENCE item_orders_seq;

/*============================================*/
/*            Utworzenie sekwencji            */
/*============================================*/

CREATE SEQUENCE contract_types_seq;
CREATE SEQUENCE contracts_seq;
CREATE SEQUENCE employees_seq;
CREATE SEQUENCE customers_seq;
CREATE SEQUENCE service_types_seq;
CREATE SEQUENCE status_types_seq;
CREATE SEQUENCE services_seq;
CREATE SEQUENCE pricings_seq;
CREATE SEQUENCE product_categories_seq;
CREATE SEQUENCE item_orders_seq;

/*============================================*/
/*             Uzupe³nienie danymi            */
/*============================================*/

/*
    Uzupe³nienie tabeli CONTRACT_TYPES przyk³adowymi danymi
*/

INSERT INTO contract_types  (id, contract_name) 
VALUES (contract_types_seq.nextval,'Praktyki');

INSERT INTO contract_types  (id, contract_name) 
VALUES (contract_types_seq.nextval,'Sta¿');

INSERT INTO contract_types  (id, contract_name) 
VALUES (contract_types_seq.nextval,'Umowa o dzie³o');

INSERT INTO contract_types  (id, contract_name) 
VALUES (contract_types_seq.nextval,'Umowa o zlecenie');

INSERT INTO contract_types  (id, contract_name) 
VALUES (contract_types_seq.nextval,'Umowa o pracê na czas okreœlony');

INSERT INTO contract_types  (id, contract_name) 
VALUES (contract_types_seq.nextval,'Umowa o pracê na czas nieokreœlony');

INSERT INTO contract_types  (id, contract_name) 
VALUES (contract_types_seq.nextval,'B2B');

INSERT INTO contract_types  (id, contract_name) 
VALUES (contract_types_seq.nextval,'Umowa agencyjna');

INSERT INTO contract_types  (id, contract_name) 
VALUES (contract_types_seq.nextval,'Kontrakt mened¿erski');

INSERT INTO contract_types  (id, contract_name) 
VALUES (contract_types_seq.nextval,'Umowa na okres próbny');

/*
    Uzupe³nienie tabeli CONTRACTS przyk³adowymi danymi
*/

INSERT INTO contracts  (id, contract_type, signed_date, expires_date, salary, job_title) 
VALUES (
    contracts_seq.nextval, 
    6, 
    TO_DATE('15-01-2020', 'DD-MM-YYYY'),
    null,
    5672,
    'W³aœciciel'
);

INSERT INTO contracts  (id, contract_type, signed_date, expires_date, salary, job_title) 
VALUES (
    contracts_seq.nextval, 
    6, 
    TO_DATE('20-01-2020', 'DD-MM-YYYY'),
    null,
    4245,
    'Kierownik dzia³u napraw komputerów osobistych'
);

INSERT INTO contracts  (id, contract_type, signed_date, expires_date, salary, job_title) 
VALUES (
    contracts_seq.nextval, 
    6, 
    TO_DATE('21-01-2020', 'DD-MM-YYYY'),
    null,
    4245,
    'Kierownik dzia³u napraw telefonów komórkowych'
);

INSERT INTO contracts  (id, contract_type, signed_date, expires_date, salary, job_title) 
VALUES (
    contracts_seq.nextval, 
    6, 
    TO_DATE('27-01-2020', 'DD-MM-YYYY'),
    null,
    3570,
    'Starszy serwisant'
);

INSERT INTO contracts  (id, contract_type, signed_date, expires_date, salary, job_title) 
VALUES (
    contracts_seq.nextval, 
    6, 
    TO_DATE('03-02-2020', 'DD-MM-YYYY'),
    null,
    3620,
    'Starszy serwisant'
);

INSERT INTO contracts  (id, contract_type, signed_date, expires_date, salary, job_title) 
VALUES (
    contracts_seq.nextval, 
    7, 
    TO_DATE('10-02-2020', 'DD-MM-YYYY'),
    null,
    3800,
    'Starszy serwisant'
);

INSERT INTO contracts  (id, contract_type, signed_date, expires_date, salary, job_title) 
VALUES (
    contracts_seq.nextval, 
    5, 
    TO_DATE('15-02-2020', 'DD-MM-YYYY'),
    TO_DATE('15-02-2021', 'DD-MM-YYYY'),
    3015,
    'M³odszy serwisant'
);

INSERT INTO contracts  (id, contract_type, signed_date, expires_date, salary, job_title) 
VALUES (
    contracts_seq.nextval, 
    5, 
    TO_DATE('25-02-2020', 'DD-MM-YYYY'),
    TO_DATE('25-02-2021', 'DD-MM-YYYY'),
    3107,
    'M³odszy serwisant'
);

INSERT INTO contracts  (id, contract_type, signed_date, expires_date, salary, job_title) 
VALUES (
    contracts_seq.nextval, 
    2, 
    TO_DATE('03-03-2020', 'DD-MM-YYYY'),
    TO_DATE('03-04-2020', 'DD-MM-YYYY'),
    2500,
    'Serwisant sta¿ysta'
);

INSERT INTO contracts  (id, contract_type, signed_date, expires_date, salary, job_title) 
VALUES (
    contracts_seq.nextval, 
    1, 
    TO_DATE('08-03-2020', 'DD-MM-YYYY'),
    TO_DATE('08-04-2020', 'DD-MM-YYYY'),
    0,
    'Praktykant'
);

/*
    Uzupe³nienie tabeli EMPLOYEES przyk³adowymi danymi
*/

INSERT INTO employees  (id, first_name, last_name, phone, email, pesel, sex, manager_id, contract_id) 
VALUES (
    employees_seq.nextval, 
    'Jorge',
    'Morrison',
    '841319326',
    'jorge.morrison@example.com',
    '62060601122',
    'M',
    null,
    1
);

INSERT INTO employees  (id, first_name, last_name, phone, email, pesel, sex, manager_id, contract_id) 
VALUES (
    employees_seq.nextval, 
    'Ronnie',
    'Cruz',
    '944304539',
    'ronnie.cruz@example.com',
    '51050401122',
    'M',
    1,
    2
);

INSERT INTO employees  (id, first_name, last_name, phone, email, pesel, sex, manager_id, contract_id) 
VALUES (
    employees_seq.nextval, 
    'Carter',
    'Hayes',
    '507650426',
    'carter.hayes@example.com',
    '54010801122',
    'M',
    1,
    3
);

INSERT INTO employees  (id, first_name, last_name, phone, email, pesel, sex, manager_id, contract_id) 
VALUES (
    employees_seq.nextval, 
    'Ashley',
    'Rice',
    '865908855',
    'ashley.rice@example.com',
    '59070401122',
    'K',
    2,
    4
);

INSERT INTO employees  (id, first_name, last_name, phone, email, pesel, sex, manager_id, contract_id) 
VALUES (
    employees_seq.nextval, 
    'Irene',
    'Mcdonalid',
    '934892675',
    'irene.mcdonalid@example.com',
    '82020701122',
    'K',
    3,
    5
);

INSERT INTO employees  (id, first_name, last_name, phone, email, pesel, sex, manager_id, contract_id) 
VALUES (
    employees_seq.nextval, 
    'Arthur',
    'Anderson',
    '290207644',
    'arthur.anderson@example.com',
    '74071001122',
    'M',
    2,
    6
);

INSERT INTO employees  (id, first_name, last_name, phone, email, pesel, sex, manager_id, contract_id) 
VALUES (
    employees_seq.nextval, 
    'Danny',
    'Andrews',
    '284347903',
    'danny.andrews@example.com',
    '91040201122',
    'M',
    3,
    7
);

INSERT INTO employees  (id, first_name, last_name, phone, email, pesel, sex, manager_id, contract_id) 
VALUES (
    employees_seq.nextval, 
    'Jason',
    'Simpson',
    '125869760',
    'jason.simpson@example.com',
    '58020801122',
    'M',
    2,
    8
);

INSERT INTO employees  (id, first_name, last_name, phone, email, pesel, sex, manager_id, contract_id) 
VALUES (
    employees_seq.nextval, 
    'Alfredo',
    'Boyd',
    '408392143',
    'alfredo.boyd@example.com',
    '96030901122',
    'M',
    3,
    9
);

INSERT INTO employees  (id, first_name, last_name, phone, email, pesel, sex, manager_id, contract_id) 
VALUES (
    employees_seq.nextval, 
    'Zoey',
    'Jimenez',
    '728055167',
    'zoey.jimenez@example.com',
    '91030501122',
    'K',
    2,
    10
);

/*
    Uzupe³nienie tabeli STATUS_TYPES przyk³adowymi danymi
*/

INSERT INTO status_types  (id, name) 
VALUES (status_types_seq.nextval,'Zg³oszenie przyjête');

INSERT INTO status_types  (id, name) 
VALUES (status_types_seq.nextval,'Oczekuje na diagnozê');

INSERT INTO status_types  (id, name) 
VALUES (status_types_seq.nextval,'W diagnozie');

INSERT INTO status_types  (id, name) 
VALUES (status_types_seq.nextval,'Oczekuje na czêœci zamienne');

INSERT INTO status_types  (id, name) 
VALUES (status_types_seq.nextval,'Oczekuje na serwis');

INSERT INTO status_types  (id, name) 
VALUES (status_types_seq.nextval,'W trakcie serwisu');

INSERT INTO status_types  (id, name) 
VALUES (status_types_seq.nextval,'Oczekuje na kontrole jakoœci');

INSERT INTO status_types  (id, name) 
VALUES (status_types_seq.nextval,'Kontrola jakoœci serwisu');

INSERT INTO status_types  (id, name) 
VALUES (status_types_seq.nextval,'Gotowa do wydania');

INSERT INTO status_types  (id, name) 
VALUES (status_types_seq.nextval,'Zakoñczono');

/*
    Uzupe³nienie tabeli SERVICE_TYPES przyk³adowymi danymi
*/

INSERT INTO service_types  (id, name) 
VALUES (service_types_seq.nextval,'Konserwacja');

INSERT INTO service_types  (id, name) 
VALUES (service_types_seq.nextval,'Wymiana podzespo³ów');

INSERT INTO service_types  (id, name) 
VALUES (service_types_seq.nextval,'Naprawa Hardware');

INSERT INTO service_types  (id, name) 
VALUES (service_types_seq.nextval,'Naprawa Software');

INSERT INTO service_types  (id, name) 
VALUES (service_types_seq.nextval,'Konfiguracja Software');

INSERT INTO service_types  (id, name) 
VALUES (service_types_seq.nextval,'Z³o¿enie PC');

INSERT INTO service_types  (id, name) 
VALUES (service_types_seq.nextval,'Monta¿ os³ony na ekran');

INSERT INTO service_types  (id, name) 
VALUES (service_types_seq.nextval,'Odbiór elektroodpadów');

INSERT INTO service_types  (id, name) 
VALUES (service_types_seq.nextval,'Diagnoza');

INSERT INTO service_types  (id, name) 
VALUES (service_types_seq.nextval,'Doradztwo');

/*
    Uzupe³nienie tabeli CUSTOMERS przyk³adowymi danymi
*/

INSERT INTO customers  (id, first_name, last_name, phone, email) 
VALUES (
    customers_seq.nextval, 
    'Eleanor',
    'Dixon',
    '669196660',
    'eleanor.dixon@example.com'
);

INSERT INTO customers  (id, first_name, last_name, phone, email) 
VALUES (
    customers_seq.nextval, 
    'Armando',
    'Pena',
    '597337761',
    'armando.pena@example.com'
);

INSERT INTO customers  (id, first_name, last_name, phone, email) 
VALUES (
    customers_seq.nextval, 
    'Frances',
    'Jones',
    '260913213',
    'frances.jones@example.com'
);

INSERT INTO customers  (id, first_name, last_name, phone, email) 
VALUES (
    customers_seq.nextval, 
    'Minnie',
    'Turner',
    '584110839',
    'minnie.turner@example.com'
);

INSERT INTO customers  (id, first_name, last_name, phone, email) 
VALUES (
    customers_seq.nextval, 
    'Gabe',
    'Gonzales',
    '160086095',
    'gabe.gonzales@example.com'
);

INSERT INTO customers  (id, first_name, last_name, phone, email) 
VALUES (
    customers_seq.nextval, 
    'Lance',
    'Kim',
    '263232091',
    'lance.kim@example.com'
);

INSERT INTO customers  (id, first_name, last_name, phone, email) 
VALUES (
    customers_seq.nextval, 
    'Clifton',
    'Brooks',
    '025582263',
    'clifton.brooks@example.com'
);

INSERT INTO customers  (id, first_name, last_name, phone, email) 
VALUES (
    customers_seq.nextval, 
    'Sylvia',
    'Mccoy',
    '102782683',
    'sylvia.mccoy@example.com'
);

INSERT INTO customers  (id, first_name, last_name, phone, email) 
VALUES (
    customers_seq.nextval, 
    'Phyllis',
    'Hanson',
    '572248194',
    'phyllis.hanson@example.com'
);

INSERT INTO customers  (id, first_name, last_name, phone, email) 
VALUES (
    customers_seq.nextval, 
    'Marjorie',
    'Holt',
    '512657032',
    'marjorie.holt@example.com'
);

/*
    Uzupe³nienie tabeli PRODUCT_CATEGORIES przyk³adowymi danymi
*/

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Dyski twarde HDD i SSD');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Karty graficzne');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Procesory');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'P³yty g³ówne');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Pamiêci RAM');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Obudowy komputerowe');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Zasilacze komputerowe');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Ch³odzenia komputerowe');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Karty dŸwiêkowe');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Napêdy optyczne');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Obudowy dysków');

INSERT INTO product_categories  (id, name) 
VALUES (product_categories_seq.nextval,'Akcesoria GSM');

/*
    Uzupe³nienie tabeli SERVICES przyk³adowymi danymi
*/

INSERT INTO services  (id, service_type, employee_id, customer_id, created_at, status, customer_description, service_description) 
VALUES (
    services_seq.nextval, 
    3,
    10,
    1,
    TO_DATE('10-03-2020', 'DD-MM-YYYY'),
    10,
    'Przegrzewanie procesora, wystêpuje równie¿ gdy komputer jest bezczynny.',
    'Brak pasty termoprzewodz¹cej pod uk³adem ch³odzenia, za³o¿ono now¹ pastê'
);

INSERT INTO services  (id, service_type, employee_id, customer_id, created_at, status, customer_description, service_description) 
VALUES (
    services_seq.nextval, 
    7,
    9,
    2,
    TO_DATE('20-03-2020', 'DD-MM-YYYY'),
    10,
    'Polecenie za³o¿enia folii ochronnej na ekran telefonu',
    'Za³o¿ono foliê na ekran telefonu'
);

INSERT INTO services  (id, service_type, employee_id, customer_id, created_at, status, customer_description, service_description) 
VALUES (
    services_seq.nextval, 
    4,
    8,
    3,
    TO_DATE('1-04-2020', 'DD-MM-YYYY'),
    10,
    'Od czasu zainstalowania i uruchomienia programu d0nt_0pen_this.exe system Windows przesta³ siê w³¹czaæ.',
    'Wykonano reinstalacje systemu Windows 10.'
);

INSERT INTO services  (id, service_type, employee_id, customer_id, created_at, status, customer_description, service_description) 
VALUES (
    services_seq.nextval, 
    3,
    7,
    4,
    TO_DATE('15-04-2020', 'DD-MM-YYYY'),
    10,
    'Kompletny brak obrazu z komputera, sprawdzone na 2 wyjœciach HDMI i 2 monitorach',
    'Spalona karta graficzna, wymiana na now¹.'
);

INSERT INTO services  (id, service_type, employee_id, customer_id, created_at, status, customer_description, service_description) 
VALUES (
    services_seq.nextval, 
    2,
    6,
    5,
    TO_DATE('10-05-2020', 'DD-MM-YYYY'),
    10,
    'Polecenie do³o¿enia koœci pamiêci RAM, aby osi¹gn¹æ 16GB RAM (obecnie 8GB), polecenie do³o¿enia drugiego dysku o pojemnoœci 2TB',
    'Zakupiono i do³o¿ono koœæ RAMu o pojemnoœci 8GB, do³o¿ono dysk o pojemnoœci 2TB'
);

INSERT INTO services  (id, service_type, employee_id, customer_id, created_at, status, customer_description, service_description) 
VALUES (
    services_seq.nextval, 
    9,
    5,
    6,
    TO_DATE('20-05-2020', 'DD-MM-YYYY'),
    10,
    'Laptop zalany kaw¹, nie w³¹cza siê',
    'Zwarcie uk³adu zasilania, uk³ad zasilania do wymiany'
);

INSERT INTO services  (id, service_type, employee_id, customer_id, created_at, status, customer_description, service_description) 
VALUES (
    services_seq.nextval, 
    6,
    4,
    7,
    TO_DATE('01-06-2020', 'DD-MM-YYYY'),
    7,
    'Polecenie skompletowania i budowy stacji komputerowej przeznaczonej do grania w gry wideo, maksymalny bud¿et 4000 z³. System wymagany przez klienta: Windows 10',
    'Skompletowano i z³o¿ono komputer. Zainstalowano wskazany system operacyjny.'
);

INSERT INTO services  (id, service_type, employee_id, customer_id, created_at, status, customer_description, service_description) 
VALUES (
    services_seq.nextval, 
    1,
    5,
    8,
    TO_DATE('03-06-2020', 'DD-MM-YYYY'),
    10,
    'Polecenie wyczyszczenia laptopa',
    'Laptop zosta³ otworzony i wyczyszczony z zabrudzeñ, za³o¿ona zosta³a te¿ nowa pasta na procesorze.'
);

INSERT INTO services  (id, service_type, employee_id, customer_id, created_at, status, customer_description, service_description) 
VALUES (
    services_seq.nextval, 
    3,
    4,
    9,
    TO_DATE('5-06-2020', 'DD-MM-YYYY'),
    3,
    'Komputer przesta³ siê w³¹czaæ',
    null
);

INSERT INTO services  (id, service_type, employee_id, customer_id, created_at, status, customer_description, service_description) 
VALUES (
    services_seq.nextval, 
    2,
    5,
    10,
    TO_DATE('09-06-2020', 'DD-MM-YYYY'),
    5,
    'Bateria w laptopie starcza na 20 minut u¿ytkowania bez pod³¹czenia zasilacza, polecenie wymiany baterii na now¹',
    null
);

/*
    Uzupe³nienie tabeli PRICINGS przyk³adowymi danymi
*/

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    1,
    50,
    'Diagnoza'
);

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    1,
    50,
    'Wymiana pasty termoprzewodz¹cej'
);

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    2,
    20,
    'Za³o¿enie folii ochronnej'
);

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    3,
    50,
    'Diagnoza'
);

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    3,
    50,
    'Reinstalacja systemu'
);

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    4,
    50,
    'Diagnoza'
);

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    4,
    50,
    'Wymiana podzespo³ów'
);

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    5,
    50,
    'Do³o¿enie podzespo³ów'
);

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    6,
    100,
    'Diagnoza'
);

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    7,
    100,
    'Z³o¿enie stacji komputerowej i instalacja systemu'
);

INSERT INTO pricings  (id, service_id, value, description) 
VALUES (
    pricings_seq.nextval, 
    8,
    100,
    'Czyszczenie i nowa pasta'
);

/*
    Uzupe³nienie tabeli ITEM_ORDERS przyk³adowymi danymi
*/

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    1,
    'Thermal Grizzly Kryonaut 1g',
    8,
    1,
    35
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    2,
    '3mk Flexible Glass do Xiaomi Redmi Note 8 Pro',
    12,
    1,
    39
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    4,
    'Gigabyte GeForce GTX 1660 SUPER OC 6GB GDDR6',
    2,
    1,
    1199
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    5,
    'HyperX 8GB (1x8GB) 2666MHz CL15 Impact Black',
    5,
    1,
    179
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    5,
    'Seagate BARRACUDA 2TB 7200obr. 256MB',
    1,
    1,
    299
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    7,
    'AMD Ryzen 5 3600',
    3,
    1,
    849
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    7,
    'ASRock Fatal1ty B450 Gaming K4',
    4,
    1,
    459
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    7,
    'PNY 16GB (2x8GB) 3200MHz CL16 XLR8 Gaming',
    5,
    1,
    399
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    7,
    'ASRock Radeon RX 5600 XT Challenger D OC 6GB GDDR6',
    2,
    1,
    1529
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    7,
    'SilentiumPC Regnum RG6V TG Pure Black',
    6,
    1,
    269
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    7,
    'SilentiumPC Supremo M2 550W 80 Plus Gold',
    7,
    1,
    309
);

INSERT INTO item_orders  (id, service_id, product_name, product_category, quantity, unit_price) 
VALUES (
    item_orders_seq.nextval, 
    7,
    'Plextor 512GB 2,5" SATA SSD M8VC',
    1,
    1,
    299
);


