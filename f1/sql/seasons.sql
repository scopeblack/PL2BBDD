\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla circuits'
CREATE TABLE IF NOT EXISTS ddbb.seasons(
    year TEXT,
    url TEXT
);

\echo 'Cargando datos'
\COPY ddbb.seasons    FROM f1/datos/seasons.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas seasons hay" 
SELECT
    count(*) as Número_de_seasons
    FROM ddbb.seasons                                                            -- from seasons
    ;
\echo "Mostrar las seasons en país específico" 
SELECT
    *
    FROM ddbb.seasons
    WHERE seasons.year='2009'
    ;
ROLLBACK;                       -- importante! permite correr el script multiples veces...