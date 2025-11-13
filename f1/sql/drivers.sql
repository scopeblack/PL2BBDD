\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla circuits'
CREATE TABLE IF NOT EXISTS ddbb.drivers(
    driverId       TEXT
    ,driverRef     TEXT
    ,number        TEXT
    ,code          TEXT
    ,forename      TEXT
    ,surname       TEXT
    ,dob           TEXT
    ,nationality   TEXT
    ,url           TEXT
);

\echo 'Cargando datos'
\COPY ddbb.drivers    FROM f1/datos/drivers.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas drivers hay" 
SELECT
    count(*) as Número_de_drivers
    FROM ddbb.drivers                                                            -- from drivers
    ;
\echo "Mostrar las drivers en país específico" 
SELECT
    *
    FROM ddbb.drivers
    WHERE drivers.nationality='Spanish'
    ;
ROLLBACK;                       -- importante! permite correr el script multiples veces...