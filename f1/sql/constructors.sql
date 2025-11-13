\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla circuits'
CREATE TABLE IF NOT EXISTS ddbb.constructors(
    constructorId       TEXT
    ,constructorRef     TEXT
    ,name               TEXT
    ,nationality        TEXT
    ,url                TEXT
);

\echo 'Cargando datos'
\COPY ddbb.constructors FROM f1/datos/constructors.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas constructors hay" 
SELECT
    count(*) as Número_de_constructors
    FROM ddbb.constructors
    ;
\echo "Mostrar las constructors en país específico" 
SELECT
    *
    FROM ddbb.constructors
    WHERE constructors.nationality='Spanish'
    ;
ROLLBACK;                       -- importante! permite correr el script multiples veces...