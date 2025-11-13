\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla circuits'
CREATE TABLE IF NOT EXISTS ddbb.races(
    raceId TEXT,
    year TEXT,
    round TEXT,
    circuitId TEXT,
    name TEXT,
    date TEXT,
    time TEXT,
    url TEXT,
    fp1_date TEXT,
    fp1_time TEXT,
    fp2_date TEXT,
    fp2_time TEXT,
    fp3_date TEXT,
    fp3_time TEXT,
    quali_date TEXT,
    quali_time TEXT,
    sprint_date TEXT,
    sprint_time TEXT
);

\echo 'Cargando datos'
\COPY ddbb.races FROM f1/datos/races.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas races hay" 
SELECT
    count(*) as Número_de_races
    FROM ddbb.races                                                            -- from races
    ;
\echo "Mostrar las races en país específico" 
SELECT
    *
    FROM ddbb.races
    WHERE races.year='2009'
    ;
ROLLBACK;                       -- importante! permite correr el script multiples veces...