/*============================================*/
/*  Usuni�cie tabel stworzonych przez skrypt  */
/*============================================*/

DROP TABLE contract_types CASCADE CONSTRAINTS;  -- Usuni�cie tabeli contract_types wraz ze wszystkimi ograniczeniami integralno�ciowymi
DROP TABLE contracts CASCADE CONSTRAINTS;       -- Usuni�cie tabeli contracts wraz ze wszystkimi ograniczeniami integralno�ciowymi

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