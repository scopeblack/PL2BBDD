\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla circuits'
CREATE TABLE IF NOT EXISTS ddbb.results(
    resultados_id TEXT,
    gpid TEXT,
    pilotoid TEXT,
    escuderiaid TEXT,
    número TEXT,
    pos_parrilla TEXT,
    posición TEXT,
    posicióntexto TEXT,
    posiciónorden TEXT,
    puntos TEXT,
    vueltas TEXT,
    tiempo TEXT,
    tiempomilsgs TEXT,
    vueltarápida TEXT,
    puesto_campeonato TEXT,
    vueltarápida_tiempo TEXT,
    vueltarápida_velocidad TEXT,
    estadoid TEXT
);

\echo 'Cargando datos'
\COPY ddbb.results FROM f1/datos/results.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas results hay" 
SELECT
    count(*) as Número_de_results
    FROM ddbb.results                                                            -- from results
    ;
\echo "Mostrar las results en país específico" 
SELECT
    *
    FROM ddbb.results
    WHERE results.pilotoid='1'
    ;
ROLLBACK;                       -- importante! permite correr el script multiples veces...