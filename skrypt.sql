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
        id              liczba          identyfikator
        contract_type   liczba          identyfikator typu umowy z tabeli contract_types
        signed_date     data            data podpisania umowy
        expires_date    data            data wyga�ni�cia umowy
        salary          liczba          warto�� wyp�aty
        job_title       napis           nazwa stanowiska
        
    Ograniczenia integralno�ciowe:
        id              klucz g��wny
        contract_type   klucz obcy,
                        nie mo�e by� pusty (NOT NULL)
                        musi by� unikalny (UNIQUE)
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
    
    CONSTRAINT      contracts_pk                PRIMARY KEY (id),
    CONSTRAINT      contracts_fk1               FOREIGN KEY (contract_type) REFERENCES contract_types (id),
    CONSTRAINT      contracts_contract_type_uq  UNIQUE (contract_type)
);