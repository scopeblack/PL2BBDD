\pset pager off

SET client_encoding = 'UTF8';

BEGIN;
\echo 'creando el esquema para la BBDD de películas'
CREATE SCHEMA IF NOT EXISTS f1;

\echo 'creando un esquema temporal'
CREATE TABLE IF NOT EXISTS f1.pilotos_temp(
     pilotoID            TEXT 
    ,pilotoref           TEXT 
    ,número              TEXT
    ,código              TEXT
    ,nombre              TEXT
    ,apellido            TEXT
    ,f_nacimiento        TEXT
    ,nacionalidad        TEXT
    ,url                 TEXT
);

CREATE TABLE IF NOT EXISTS f1.escuderias_temp(
     escuderiaID         TEXT 
    ,escuderiaref        TEXT 
    ,nombre              TEXT
    ,nacionalidad        TEXT
    ,url                 TEXT
);

CREATE TABLE IF NOT EXISTS f1.circuitos_temp(
     circuitoID         TEXT 
    ,circuitoref        TEXT 
    ,nombre             TEXT
    ,localización       TEXT
    ,pais               TEXT
    ,latitud            TEXT
    ,longitud           TEXT
    ,altura             TEXT
    ,url                TEXT
);

CREATE TABLE IF NOT EXISTS f1.gps_temp(
     gpID              TEXT 
    ,año               TEXT 
    ,ronda             TEXT
    ,circuitoID        TEXT
    ,nombregp          TEXT
    ,fecha             TEXT
    ,hora              TEXT
    ,url               TEXT
    ,fecha_fp1         TEXT
    ,hora_fp1          TEXT
    ,fecha_fp2         TEXT
    ,hora_fp2          TEXT
    ,fecha_fp3         TEXT
    ,hora_fp3          TEXT
    ,fecha_quali       TEXT
    ,hora_quali        TEXT
    ,fecha_carrera     TEXT
    ,hora_carrera      TEXT
);

CREATE TABLE IF NOT EXISTS f1.resultados_temp(
     resultados_ID            TEXT 
    ,gpID                     TEXT 
    ,pilotoID                 TEXT  
    ,escuderiaID              TEXT
    ,número                   TEXT
    ,pos_parrilla             TEXT
    ,posición                 TEXT
    ,posiciónTexto            TEXT
    ,posiciónOrden            TEXT
    ,puntos                   TEXT            
    ,vueltas                  TEXT
    ,tiempo                   TEXT
    ,tiempoMilsgs             TEXT
    ,vueltarápida             TEXT
    ,puesto_campeonato        TEXT
    ,vueltarápida_tiempo      TEXT        
    ,vueltarápida_velocidad   TEXT        
    ,estadoID                  TEXT
);

CREATE TABLE IF NOT EXISTS f1.resultados_temp2(
     resultados_ID            TEXT 
    ,gpID                     TEXT 
    ,pilotoID                 TEXT  
    ,escuderiaID              TEXT
    ,número                   TEXT
    ,pos_parrilla             TEXT
    ,posición                 TEXT
    ,posiciónTexto            TEXT
    ,posiciónOrden            TEXT
    ,puntos                   TEXT            
    ,vueltas                  TEXT
    ,tiempo                   TEXT
    ,tiempoMilsgs             TEXT
    ,vueltarápida             TEXT
    ,puesto_campeonato        TEXT
    ,vueltarápida_tiempo      TEXT        
    ,vueltarápida_velocidad   TEXT        
    ,estadoID                  TEXT
);

CREATE TABLE IF NOT EXISTS f1.vueltas_temp(
     gpID                     TEXT 
    ,pilotoID                 TEXT  
    ,vuelta                   TEXT
    ,posición                 TEXT  
    ,tiempo                   TEXT
    ,tiempoMilsgs             TEXT
);

CREATE TABLE IF NOT EXISTS f1.pit_stops_temp(
     gpID                     TEXT 
    ,pilotoID                 TEXT  
    ,parada                   TEXT
    ,vuelta                   TEXT
    ,hora                     TEXT  
    ,duración                 TEXT
    ,duraciónMilsgs           TEXT
);

CREATE TABLE IF NOT EXISTS f1.calificación_temp(
     calificaciónID           TEXT      
    ,gpID                     TEXT 
    ,pilotoID                 TEXT  
    ,escuderíaID              TEXT  
    ,numero                   TEXT
    ,posición                 TEXT
    ,q1                       TEXT  
    ,q2                       TEXT
    ,q3                       TEXT
);

CREATE TABLE IF NOT EXISTS f1.temporadas_temp(
     año                      TEXT      
    ,url                      TEXT 
);

CREATE TABLE IF NOT EXISTS f1.estados_temp(
     estadoID                 TEXT      
    ,estado                   TEXT 
);

\echo 'creando el esquema definitivo'

CREATE TABLE IF NOT EXISTS f1.circuitos(
     circuitoref        TEXT 
    ,nombre             TEXT
    ,localización       TEXT
    ,pais               TEXT
    ,latitud            NUMERIC
    ,longitud           NUMERIC
    ,altura             INTEGER
    ,url                TEXT
    ,CONSTRAINT circuitos_pk PRIMARY KEY (circuitoref)
);

CREATE TABLE IF NOT EXISTS f1.pilotos(
     pilotoref           TEXT 
    ,número              INTEGER
    ,código              CHAR(3)
    ,nombre              TEXT
    ,apellido            TEXT
    ,f_nacimiento        DATE
    ,nacionalidad        TEXT
    ,url                 TEXT
    ,CONSTRAINT pilotos_pk PRIMARY KEY (pilotoref)
);

CREATE TABLE IF NOT EXISTS f1.temporadas(
     año                      INTEGER      
    ,url                      TEXT 
    ,CONSTRAINT temporadas_pk PRIMARY KEY (año)
);

CREATE TABLE IF NOT EXISTS f1.escuderías(
     escuderíaref        TEXT 
    ,nombre              TEXT
    ,nacionalidad        TEXT
    ,url                 TEXT
    ,CONSTRAINT escuderías_pk PRIMARY KEY (escuderíaref)
);

CREATE TABLE IF NOT EXISTS f1.gps(
     nombregp            TEXT 
    ,año                 INT 
    ,circuitoref         TEXT
    ,ronda               INT
    ,fechayhora          TIMESTAMP
    ,url                 TEXT
    ,CONSTRAINT gps_pk PRIMARY KEY (nombregp,año)
    ,CONSTRAINT gps_fk1 FOREIGN KEY (año) REFERENCES f1.temporadas (año) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
    ,CONSTRAINT gps_fk2 FOREIGN KEY (circuitoref) REFERENCES f1.circuitos (circuitoref) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS f1.pilotos_corren_gps(
     pilotoref           TEXT
    ,escuderiaref        TEXT   
    ,nombregp            TEXT 
    ,año                 INT 
    ,posición            INT
    ,puntos              INT
    ,estado              TEXT
    ,CONSTRAINT pilotos_corren_gps_pk PRIMARY KEY (pilotoref,escuderiaref,nombregp,año)
    ,CONSTRAINT pilotos_corren_gps_fk1 FOREIGN KEY (nombregp,año) REFERENCES f1.gps (nombregp,año) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
    ,CONSTRAINT pilotos_corren_gps_fk2 FOREIGN KEY (pilotoref) REFERENCES f1.pilotos (pilotoref) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
    ,CONSTRAINT pilotos_corren_gps_fk3 FOREIGN KEY (escuderiaref) REFERENCES f1.escuderías (escuderíaref) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS f1.pilotos_califican_gps(
     pilotoref           TEXT
    ,nombregp            TEXT 
    ,año                 INT 
    ,posición            INT
    ,q1                  TIME
    ,q2                  TIME
    ,q3                  TIME
    ,CONSTRAINT pilotos_califican_gps_pk PRIMARY KEY (pilotoref,nombregp,año)
    ,CONSTRAINT pilotos_califican_gps_fk1 FOREIGN KEY (nombregp,año) REFERENCES f1.gps (nombregp,año) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
    ,CONSTRAINT pilotos_califican_gps_fk2 FOREIGN KEY (pilotoref) REFERENCES f1.pilotos (pilotoref) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS f1.pilotos_corren_vueltas_gps(
     pilotoref           TEXT
    ,nombregp            TEXT 
    ,año                 INT 
    ,posición            INT
    ,vuelta              INT
    ,tiempo              TIME
    ,CONSTRAINT pilotos_corre_vueltas_gps_pk PRIMARY KEY (pilotoref,nombregp,año,vuelta)
    ,CONSTRAINT pilotos_corren_vueltas_gps_fk1 FOREIGN KEY (nombregp,año) REFERENCES f1.gps (nombregp,año) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
    ,CONSTRAINT pilotos_corren_vueltas_gps_fk2 FOREIGN KEY (pilotoref) REFERENCES f1.pilotos (pilotoref) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS f1.pilotos_realizan_paradas_gps(
     pilotoref           TEXT
    ,nombregp            TEXT 
    ,año                 INT 
    ,parada              INT
    ,vuelta              INT
    ,hora                TIME
    ,duración            TIME
    ,CONSTRAINT pilotos_realizan_paradas_gps_pk PRIMARY KEY (pilotoref,nombregp,año,vuelta)
    ,CONSTRAINT pilotos_realizan_paradas_gps_fk1 FOREIGN KEY (pilotoref,nombregp,año,vuelta) REFERENCES
    f1.pilotos_corren_vueltas_gps (pilotoref,nombregp,año,vuelta) MATCH FULL
    ON DELETE RESTRICT ON UPDATE CASCADE
);

\COPY f1.pilotos_temp    FROM f1/datos/drivers.csv WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY f1.escuderias_temp    FROM f1/datos/constructors.csv WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY f1.circuitos_temp    FROM f1/datos/circuits.csv WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY f1.gps_temp    FROM f1/datos/races.csv WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY f1.resultados_temp    FROM f1/datos/results.csv WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY f1.vueltas_temp    FROM f1/datos/lap_times.csv WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY f1.pit_stops_temp    FROM f1/datos/pit_stops.csv WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY f1.calificación_temp    FROM f1/datos/qualifying.csv WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY f1.temporadas_temp    FROM f1/datos/seasons.csv WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');
\COPY f1.estados_temp    FROM f1/datos/status.csv WITH (FORMAT csv, HEADER, DELIMITER ',', NULL '\N', ENCODING 'UTF-8');

\echo 'carga de datos'

\echo 'cargando circuitos'
INSERT INTO f1.circuitos(circuitoref,nombre,localización,pais,latitud,longitud,altura,url)
SELECT
    circuitoref,nombre,localización,pais,latitud::numeric,longitud::numeric,altura::numeric,url
FROM
    f1.circuitos_temp;

\echo 'cargando temporadas'
INSERT INTO f1.temporadas(año,url)
SELECT
    año::INT,url
FROM
    f1.temporadas_temp;

\echo 'cargando escuderias'
INSERT INTO f1.escuderías(escuderíaref,nombre,nacionalidad,url)
SELECT
    escuderiaref,nombre,nacionalidad,url
FROM
    f1.escuderias_temp;

\echo 'cargando pilotos'
INSERT INTO f1.pilotos(pilotoref,número,código,nombre,apellido,f_nacimiento,nacionalidad,url)
SELECT
    pilotoref,número::integer,código::char(3),nombre,apellido,f_nacimiento::date,nacionalidad,url
FROM
    f1.pilotos_temp;

\echo 'cargando gps'
INSERT INTO f1.gps(nombregp,año,circuitoref,ronda,fechayhora,url)
SELECT
    gp.nombregp,gp.año::INT,cs.circuitoref,gp.ronda::INT,(fecha||' '||hora)::TIMESTAMP as fechayhora,gp.url
FROM
    f1.gps_temp as gp join f1.circuitos_temp as cs on gp.circuitoID=cs.circuitoID;

\echo cargando pilotos corren gps
INSERT INTO f1.pilotos_corren_gps(pilotoref,escuderiaref,nombregp,año,posición,puntos,estado)
SELECT
    pi.pilotoref,es.escuderiaref,gp.nombregp,gp.año::INT
    ,re.posición::INT,re.puntos::NUMERIC,est.estado
FROM
    f1.resultados_temp re INNER JOIN f1.pilotos_temp pi ON re.pilotoID=pi.pilotoID
    INNER JOIN f1.escuderias_temp es ON es.escuderiaID=re.escuderiaID
    INNER JOIN f1.gps_temp gp ON re.gpID=gp.gpID
    INNER JOIN f1.estados_temp est ON re.estadoID=est.estadoID;

\echo cargando pilotos califican gps
INSERT INTO f1.pilotos_califican_gps(pilotoref,nombregp,año,posición,q1,q2,q3)
SELECT
    pi.pilotoref,gp.nombregp,gp.año::INT
    ,ca.posición::INT,TO_TIMESTAMP(ca.q1, 'MI:SS.MS')::TIME,
    TO_TIMESTAMP(ca.q2, 'MI:SS.MS')::TIME,
    TO_TIMESTAMP(ca.q3, 'MI:SS.MS')::TIME
FROM
    f1.calificación_temp ca INNER JOIN f1.pilotos_temp pi ON ca.pilotoID=pi.pilotoID
    INNER JOIN f1.gps_temp gp ON ca.gpID=gp.gpID;

\echo cargando pilotos corren vueltas de gps    
INSERT INTO f1.pilotos_corren_vueltas_gps(pilotoref,nombregp,año,posición,vuelta,tiempo)
SELECT
    pi.pilotoref,gp.nombregp,gp.año::INT
    ,vu.posición::INT,vu.vuelta::INT,
    TO_TIMESTAMP(vu.tiempo, 'MI:SS.MS')::TIME
FROM
    f1.vueltas_temp vu INNER JOIN f1.pilotos_temp pi ON vu.pilotoID=pi.pilotoID
    INNER JOIN f1.gps_temp gp ON vu.gpID=gp.gpID;

\echo cargando pilotos realizan pit stops en gps    
INSERT INTO f1.pilotos_realizan_paradas_gps(pilotoref,nombregp,año,parada,vuelta,hora,duración)
SELECT
    pi.pilotoref,gp.nombregp,gp.año::INT
    ,ps.parada::INT,ps.vuelta::INT
    ,ps.hora::TIME
    ,TO_TIMESTAMP(ps.duraciónMilsgs::INT/1000)::TIME
FROM
    f1.pit_stops_temp ps INNER JOIN f1.pilotos_temp pi ON ps.pilotoID=pi.pilotoID
    INNER JOIN f1.gps_temp gp ON ps.gpID=gp.gpID;



\echo 'circuitos_temp'
SELECT 
    COUNT(*)
FROM   
    f1.circuitos_temp;

\echo 'circuitos'
SELECT 
    COUNT(*)
FROM   
    f1.circuitos;

\echo 'temporadas_temp'
SELECT 
    COUNT(*)
FROM   
    f1.temporadas_temp;

\echo 'temporadas'
SELECT 
    COUNT(*)
FROM   
    f1.temporadas;

\echo 'escuderias_temp'
SELECT 
    COUNT(*)
FROM   
    f1.escuderias_temp;

\echo 'escuderías'
SELECT 
    COUNT(*)
FROM   
    f1.escuderías;

\echo 'pilotos_temp'
SELECT 
    COUNT(*)
FROM   
    f1.pilotos_temp;

\echo 'pilotos'
SELECT 
    COUNT(*)
FROM   
    f1.pilotos;

\echo 'grandes premios temporal'
SELECT 
    COUNT(*)
FROM   
    f1.gps_temp;

\echo 'grandes premios'
SELECT 
    *
FROM   
    f1.gps
LIMIT 10;


\echo 'resultados temporal'
SELECT 
    COUNT(*)
FROM   
    f1.resultados_temp;

\echo 'resultados'
SELECT 
    COUNT(*)
FROM   
    f1.pilotos_corren_gps;


\echo 'calificación temporal'
SELECT 
    COUNT(*)
FROM   
    f1.calificación_temp;

\echo 'calificación'
SELECT 
    COUNT(*)
FROM   
    f1.pilotos_califican_gps;


\echo 'vueltas temporal'
SELECT 
    COUNT(*)
FROM   
    f1.vueltas_temp;

\echo 'vueltas'
SELECT 
    COUNT(*)
FROM   
    f1.pilotos_corren_vueltas_gps;

\echo 'pit stops temporal'
SELECT 
    COUNT(*)
FROM   
    f1.pit_stops_temp;

\echo 'pit stops'
SELECT 
    COUNT(*)
FROM   
    f1.pilotos_realizan_paradas_gps;

    





-- 1. Haga un listado de todos los circuitos, así cómo el número de grandes premios
-- que ha albergado cada uno. El listado estará ordenado del circuito que haya
-- acogido más carreras al que menos

SELECT nombre, count(*) as pe
FROM f1.circuitos as ci JOIN f1.gps as gps ON ci.circuitoref=gps.circuitoref 
WHERE gps.nombregp LIKE '%Grand Prix%' 
GROUP BY count(gps.nombregp) ORDER BY pene desc;

-- 2. Muestre el número de grandes premios que ha corrido Ayrton Senna así cómo el
-- total de puntos conseguidos en las mismas
-- 3. Haga un listado con el nombre y apellidos de todos los pilotos nacidos después
-- del 31 de diciembre de 1999, junto con el número de carreras en las que haya
-- participado cada uno de ellos
-- 4. Muestre el nombre de todas las escuderías españolas o italianas junto con el
-- número de grandes premios corridos
-- 5. Crea una vista donde para cada temporada se muestren los pilotos que han corrido
-- en la misma, así como los puntos totales que han obtenido cada uno en esa
-- temporada.



--CREATE VIEW nombre
--SELECT *
--FROM nombre
--LIMIT 10
--F|-#\0 Salida.txt



-- 6. Utilizando dicha vista obtén el nombre de los pilotos ganadores en las temporadas
-- del 2010 al 2015 inclusive
-- 7. Obtener el nombre de los pilotos que han ganado al menos un GP (posición = 1)
-- 8. Mostrar el número de Grandes Premios por país
-- 9. Mostrar el piloto con la vuelta más rápida en toda la historia (Se prohíbe el uso de
-- la sentencia LIMIT)
-- 10. Mostrar el número de paradas en boxes por piloto en el gran premio de Monaco
-- de 2023
-- 11. Mostrar el nombre de los pilotos que hayan participado en más de 100 premios
-- ordenados por aquellos que hayan participado en más grandes premios



COMMIT;                       
