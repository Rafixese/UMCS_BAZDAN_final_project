/*============================================*/
/*  Usuniêcie tabel stworzonych przez skrypt  */
/*============================================*/

DROP TABLE contract_types CASCADE CONSTRAINTS;  -- Usuniêcie tabeli contract_types wraz ze wszystkimi ograniczeniami integralnoœciowymi
DROP TABLE contracts CASCADE CONSTRAINTS;       -- Usuniêcie tabeli contracts wraz ze wszystkimi ograniczeniami integralnoœciowymi

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
    job_title       VARCHAR(30)     NOT NULL,
    
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