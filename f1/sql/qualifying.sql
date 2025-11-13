\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla circuits'
CREATE TABLE IF NOT EXISTS ddbb.qualifying(
    qualifyId TEXT,
    raceId TEXT,
    driverId TEXT,
    constructorId TEXT,
    number TEXT,
    position TEXT,
    q1 TEXT,
    q2 TEXT,
    q3 TEXT
);

\echo 'Cargando datos'
\COPY ddbb.qualifying FROM f1/datos/qualifying.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas qualifying hay" 
SELECT
    count(*) as Número_de_qualifying
    FROM ddbb.qualifying                                                            -- from qualifying
    ;
\echo "Mostrar las qualifying en país específico" 
SELECT
    *
    FROM ddbb.qualifying
    WHERE qualifying.driverId='1'
    ;
ROLLBACK;                       -- importante! permite correr el script multiples veces...