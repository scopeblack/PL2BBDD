\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla circuits'
CREATE TABLE IF NOT EXISTS ddbb.circuits(
    circuitId       TEXT
    ,circuitRef     TEXT
    ,name           TEXT
    ,location       TEXT
    ,country        TEXT
    ,lat           TEXT
    ,lng           TEXT
    ,alt           TEXT
    ,url           TEXT
);

\echo 'Cargando datos'
\COPY ddbb.circuits    FROM f1/datos/circuits.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas circuits hay" 
SELECT
    count(*) as Número_de_circuits
    FROM ddbb.circuits                                                            -- from circuits
    ;
\echo "Mostrar las circuits en país específico" 
SELECT
    *
    FROM ddbb.circuits
    WHERE circuits.country='Spain'
    ;
ROLLBACK;                       -- importante! permite correr el script multiples veces...