\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla circuits'
CREATE TABLE IF NOT EXISTS ddbb.lap_times(
    raceId       TEXT
    ,driverId    TEXT
    ,lap         TEXT
    ,position    TEXT
    ,time       TEXT
    ,milliseconds TEXT
);

\echo 'Cargando datos'
\COPY ddbb.lap_times    FROM f1/datos/lap_times.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas lap_times hay" 
SELECT
    count(*) as Número_de_lap_times
    FROM ddbb.lap_times                                                            -- from lap_times
    ;
\echo "Mostrar las lap_times en país específico" 
SELECT
    *
    FROM ddbb.lap_times
    WHERE lap_times.driverId='1'
    ;
ROLLBACK;                       -- importante! permite correr el script multiples veces...