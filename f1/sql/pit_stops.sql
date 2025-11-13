\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla pit_stops'
CREATE TABLE IF NOT EXISTS ddbb.pit_stops(
    raceId TEXT,
    driverId TEXT,
    stop TEXT,
    lap TEXT,
    time TEXT,
    duration TEXT,
    milliseconds TEXT
);

\echo 'Cargando datos'
\COPY ddbb.pit_stops FROM f1/datos/pit_stops.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas pit_stops hay" 
SELECT
    count(*) as Número_de_pit_stops
    FROM ddbb.pit_stops                                                            -- from pit_stops
    ;
\echo "Mostrar las circuits en país específico" 
SELECT
    *
    FROM ddbb.pit_stops
    WHERE pit_stops.driverId='1'
    ;
ROLLBACK;                       -- importante! permite correr el script multiples veces...