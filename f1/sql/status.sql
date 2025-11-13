\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla circuits'
CREATE TABLE IF NOT EXISTS ddbb.status(
    statusId TEXT,
    status TEXT
);

\echo 'Cargando datos'
\COPY ddbb.status FROM f1/datos/status.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas status hay" 
SELECT
    count(*) as Número_de_status
    FROM ddbb.status                                                            -- from status
    ;
\echo "Mostrar las status en país específico" 
SELECT
    *
    FROM ddbb.status
    WHERE status.status='Finished'
    ;
ROLLBACK;                       -- importante! permite correr el script multiples veces...