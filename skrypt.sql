/*============================================*/
/*  Usuni�cie tabel stworzonych przez skrypt  */
/*============================================*/

DROP TABLE contract_types CASCADE CONSTRAINTS;      -- Usuni�cie tabeli contract_types wraz ze wszystkimi ograniczeniami integralno�ciowymi
DROP TABLE contracts CASCADE CONSTRAINTS;           -- Usuni�cie tabeli contracts wraz ze wszystkimi ograniczeniami integralno�ciowymi
DROP TABLE employees CASCADE CONSTRAINTS;           -- Usuni�cie tabeli employees wraz ze wszystkimi ograniczeniami integralno�ciowymi
DROP TABLE customers CASCADE CONSTRAINTS;           -- Usuni�cie tabeli customers wraz ze wszystkimi ograniczeniami integralno�ciowymi
DROP TABLE service_types CASCADE CONSTRAINTS;       -- Usuni�cie tabeli service_types wraz ze wszystkimi ograniczeniami integralno�ciowymi
DROP TABLE status_types CASCADE CONSTRAINTS;        -- Usuni�cie tabeli status_types wraz ze wszystkimi ograniczeniami integralno�ciowymi
DROP TABLE services CASCADE CONSTRAINTS;            -- Usuni�cie tabeli services wraz ze wszystkimi ograniczeniami integralno�ciowymi
DROP TABLE pricings CASCADE CONSTRAINTS;            -- Usuni�cie tabeli pricings wraz ze wszystkimi ograniczeniami integralno�ciowymi
DROP TABLE product_categories CASCADE CONSTRAINTS;  -- Usuni�cie tabeli product_categories wraz ze wszystkimi ograniczeniami integralno�ciowymi
DROP TABLE item_orders CASCADE CONSTRAINTS;         -- Usuni�cie tabeli item_orders wraz ze wszystkimi ograniczeniami integralno�ciowymi


/*============================================*/
/*           Tworzenie nowych tabel           */
/*============================================*/

/*
    Utworzenie tabeli contract_types
    
    Pola tabeli:
        id              liczba      identyfikator
        contract_name   napis(30)   nazwa rodzaju umowy, np. umowa o prac�,
        
    Ograniczenia integralno�ciowe:
        id              klucz g��wny
        contract_name   nie mo�e by� pusty (NOT NULL),
                        musi by� unikalny (UNIQUE)
*/
CREATE TABLE contract_types
(
    id              NUMBER,
    contract_name   VARCHAR(30)             NOT NULL,
    
    CONSTRAINT      contract_types_pk       PRIMARY KEY(id),
    CONSTRAINT      contract_types_name_uq  UNIQUE (contract_name)
);

/*
    Utworzenie tabeli contracts
    
    Pola tabeli:
        id              liczba      identyfikator
        contract_type   liczba      identyfikator typu umowy z tabeli contract_types
        signed_date     data        data podpisania umowy
        expires_date    data        data wyga�ni�cia umowy
        salary          liczba      warto�� wyp�aty
        job_title       napis       nazwa stanowiska
        
    Ograniczenia integralno�ciowe:
        id              klucz g��wny
        contract_type   klucz obcy,
                        nie mo�e by� pusty (NOT NULL)
        signed_date     nie mo�e by� pusty (NOT NULL)
        expires_date
        salary          nie mo�e by� pusty (NOT NULL)
        job_title       nie mo�e by� pusty (NOT NULL)
*/

CREATE TABLE contracts
(
    id              NUMBER,
    contract_type   NUMBER          NOT NULL,
    signed_date     DATE            NOT NULL,
    expires_date    DATE            NULL,
    salary          NUMBER(7,2)     NOT NULL,
    job_title       VARCHAR(30)     NOT NULL,
    
    CONSTRAINT      contracts_pk    PRIMARY KEY (id),
    CONSTRAINT      contracts_fk1   FOREIGN KEY (contract_type) REFERENCES contract_types (id)
);

/*
    Utworzenie tabeli employees
    
    Pola tabeli:
        id              liczba      identyfikator
        first_name      napis       imi� pracownika
        last_name       napis       nazwisko pracownika
        phone           napis       numer telefonu
        email           napis       adres email
        pesel           napis       nr pesel
        sex             litera      p�e�: m - m�czyzna, k - kobieta
        manager_id      liczba      identyfikator prze�o�onego, relacja zwrotna do tabeli employees
        contract_id     liczba      identyfikator umowy z tabeli contracts
        
    Ograniczenia integralno�ciowe:
        id              klucz g��wny
        first_name      nie mo�e by� pusty (NOT NULL)
        last_name       nie mo�e by� pusty (NOT NULL)
        phone           nie mo�e by� pusty (NOT NULL),
                        musi by� unikalny (UNIQUE)
                        musi sk�ada� si� tylko z cyfr (CHECK)
        email           nie mo�e by� pusty (NOT NULL),
                        musi by� unikalny (UNIQUE),
                        musi pasowa� do wyra�enia regularnego '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'
        pesel           nie mo�e by� pusty (NOT NULL),
                        musi by� unikalny (UNIQUE),
                        musi sk�ada� si� tylko z cyfr (CHECK)
        sex             nie mo�e by� pusty (NOT NULL),
                        musi nale�e� do zbioru ('M', 'K') (CHECK)
        manager_id      klucz obcy
        contract_id     klucz obcy
                        nie mo�e by� pusty (NOT NULL),
                        musi by� unikalny (UNIQUE)
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
        first_name      napis       imi� klienta
        last_name       napis       nazwisko klienta
        phone           napis       numer telefonu
        email           napis       adres email
        
    Ograniczenia integralno�ciowe:
        id              klucz g��wny
        first_name      nie mo�e by� pusty (NOT NULL)
        last_name       nie mo�e by� pusty (NOT NULL)
        phone           nie mo�e by� pusty (NOT NULL),
                        musi by� unikalny (UNIQUE)
                        musi sk�ada� si� tylko z cyfr (CHECK)
        email           nie mo�e by� pusty (NOT NULL),
                        musi by� unikalny (UNIQUE),
                        musi pasowa� do wyra�enia regularnego '^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'
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
        name    napis       nazwa czynno�ci serwisowej
        
    Ograniczenia integralno�ciowe:
        id          klucz g��wny
        name        nie mo�e by� pusty (NOT NULL),
                    musi by� unikalny (UNIQUE)
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
        
    Ograniczenia integralno�ciowe:
        id          klucz g��wny
        name        nie mo�e by� pusty (NOT NULL),
                    musi by� unikalny (UNIQUE)
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
        service_type            liczba      identyfikator typu czynno�ci serwisowej z tabeli service_types
        employee_id             liczba      identyfikator pracownika odpowiedzialnego za dan� czynno�� serwisow�
        customer_id             liczba      identyfikator klienta, kt�ry zg�osi� potrzeb� serwisu
        created_at              date        data zg�oszenia serwisu
        status                  liczba      identyfikator statusu serwisu z tabeli status_types
        customer_description    napis       opis usterki lub czynno�ci serwisowej do wykonania
        service_description     napis       opis przeprowadzonych czynno�ci przez serwisanta
        
    Ograniczenia integralno�ciowe:
        id                      klucz g��wny
        service_type            klucz obcy,
                                nie mo�e by� pusty (NOT NULL)
        employee_id             klucz obcy,
                                nie mo�e by� pusty (NOT NULL)
        customer_id             klucz obcy,
                                nie mo�e by� pusty (NOT NULL)
        created_at              nie mo�e by� pusty (NOT NULL),
        status                  klucz obcy,
                                nie mo�e by� pusty (NOT NULL)
        customer_description    nie mo�e by� pusty (NOT NULL)
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
        service_id      liczba      identyfikator serwisu, do kt�rego nale�y rekord wyceny czynno�ci serwisowej
        value           liczba      cena czynno�ci serwisowej
        description     napis       kr�tki opis czynno�ci serwisowej
        
    Ograniczenia integralno�ciowe:
        id              klucz g��wny
        service_id      klucz obcy
                        nie mo�e by� pusty (NOT NULL)
        value           nie mo�e by� pusty (NOT NULL)
        description     nie mo�e by� pusty (NOT NULL)
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
        
    Ograniczenia integralno�ciowe:
        id          klucz g��wny
        name        nie mo�e by� pusty (NOT NULL),
                    musi by� unikalny (UNIQUE)
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
        service_id          liczba      identyfikator serwisu, do kt�rego nale�y rekord zam�wienia cz�ci
        product_name        napis       nazwa produktu
        product_category    liczba      identyfikator kategorii z tabeli product_categories
        quantity            liczba      liczba sztuk produktu
        unit_price          liczba      cena za sztuk�
        
    Ograniczenia integralno�ciowe:
        id                  klucz g��wny
        service_id          klucz obcy,
                            nie mo�e by� pusty (NOT NULL)
        product_name        nie mo�e by� pusty (NOT NULL)
        product_category    klucz obcy,
                            nie mo�e by� pusty (NOT NULL)
        quantity            nie mo�e by� pusty (NOT NULL)
        unit_price          nie mo�e by� pusty (NOT NULL)
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










