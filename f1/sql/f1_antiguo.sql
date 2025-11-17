\pset pager off

CREATE SCHEMA IF NOT EXISTS ddbb;

BEGIN;

\echo 'creando la tabla circuits'
CREATE TABLE IF NOT EXISTS ddbb.circuits(
    circuitId       TEXT,
    circuitRef      TEXT,
    name            TEXT,
    location        TEXT,
    country         TEXT,
    lat             TEXT,
    lng             TEXT,
    alt             TEXT,
    url             TEXT
);

\echo 'creando la tabla constructors'
CREATE TABLE IF NOT EXISTS ddbb.constructors(
    constructorId   TEXT,
    constructorRef  TEXT,
    name            TEXT,
    nationality     TEXT,
    url             TEXT
);

\echo 'creando la tabla drivers'
CREATE TABLE IF NOT EXISTS ddbb.drivers(
    driverId        TEXT,
    driverRef       TEXT,
    number          TEXT,
    code            TEXT,
    forename        TEXT,
    surname         TEXT,
    dob             TEXT,
    nationality     TEXT,
    url             TEXT
);

\echo 'creando la tabla lap_times'
CREATE TABLE IF NOT EXISTS ddbb.lap_times(
    raceId          TEXT,
    driverId        TEXT,
    lap             TEXT,
    position        TEXT,
    time            TEXT,
    milliseconds    TEXT
);

\echo 'creando la tabla pit_stops'
CREATE TABLE IF NOT EXISTS ddbb.pit_stops(
    raceId          TEXT,
    driverId        TEXT,
    stop            TEXT,
    lap             TEXT,
    time            TEXT,
    duration        TEXT,
    milliseconds    TEXT
);

\echo 'creando la tabla qualifying'
CREATE TABLE IF NOT EXISTS ddbb.qualifying(
    qualifyId       TEXT,
    raceId          TEXT,
    driverId        TEXT,
    constructorId   TEXT,
    number          TEXT,
    position        TEXT,
    q1              TEXT,
    q2              TEXT,
    q3              TEXT
);

\echo 'creando la tabla races'
CREATE TABLE IF NOT EXISTS ddbb.races(
    raceId          TEXT,
    year            TEXT,
    round           TEXT,
    circuitId       TEXT,
    name            TEXT,
    date            TEXT,
    time            TEXT,
    url             TEXT,
    fp1_date        TEXT,
    fp1_time        TEXT,
    fp2_date        TEXT,
    fp2_time        TEXT,
    fp3_date        TEXT,
    fp3_time        TEXT,
    quali_date      TEXT,
    quali_time      TEXT,
    sprint_date     TEXT,
    sprint_time     TEXT
);

\echo 'creando la tabla results'
CREATE TABLE IF NOT EXISTS ddbb.results(
    resultados_id           TEXT,
    gpid                    TEXT,
    pilotoid                TEXT,
    escuderiaid             TEXT,
    número                  TEXT,
    pos_parrilla            TEXT,
    posición                TEXT,
    posicióntexto           TEXT,
    posiciónorden           TEXT,
    puntos                  TEXT,
    vueltas                 TEXT,
    tiempo                  TEXT,
    tiempomilsgs            TEXT,
    vueltarápida            TEXT,
    puesto_campeonato       TEXT,
    vueltarápida_tiempo     TEXT,
    vueltarápida_velocidad  TEXT,
    estadoid                TEXT
);

\echo 'creando la tabla seasons'
CREATE TABLE IF NOT EXISTS ddbb.seasons(
    year    TEXT,
    url     TEXT
);

\echo 'creando la tabla status'
CREATE TABLE IF NOT EXISTS ddbb.status(
    statusId    TEXT,
    status      TEXT
);

\echo 'Cargando datos'
\COPY ddbb.circuits    FROM f1/datos/circuits.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL '\N', ENCODING 'UTF-8');
\COPY ddbb.constructors FROM f1/datos/constructors.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL '\N', ENCODING 'UTF-8');
\COPY ddbb.drivers     FROM f1/datos/drivers.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL '\N', ENCODING 'UTF-8');
\COPY ddbb.lap_times   FROM f1/datos/lap_times.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL '\N', ENCODING 'UTF-8');
\COPY ddbb.pit_stops   FROM f1/datos/pit_stops.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL '\N', ENCODING 'UTF-8');
\COPY ddbb.qualifying  FROM f1/datos/qualifying.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL '\N', ENCODING 'UTF-8');
\COPY ddbb.races       FROM f1/datos/races.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL '\N', ENCODING 'UTF-8');
\COPY ddbb.results     FROM f1/datos/results.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL '\N', ENCODING 'UTF-8');
\COPY ddbb.seasons     FROM f1/datos/seasons.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL '\N', ENCODING 'UTF-8');
\COPY ddbb.status      FROM f1/datos/status.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL '\N', ENCODING 'UTF-8');

/* ESQUEMA FINAL NUEVO */
CREATE SCHEMA IF NOT EXISTS pl1final;

-- ================================================
-- CIRCUITS
-- ================================================
CREATE TABLE IF NOT EXISTS pl1final.circuits (
    circuit_id      INTEGER PRIMARY KEY,
    circuit_ref     TEXT,
    name            TEXT NOT NULL,
    location        TEXT,
    country         TEXT,
    lat             REAL,
    lng             REAL,
    alt             INTEGER,
    url             TEXT
);

-- ================================================
-- CONSTRUCTORS
-- ================================================
CREATE TABLE IF NOT EXISTS pl1final.constructors (
    constructor_id   INTEGER PRIMARY KEY,
    constructor_ref  TEXT,
    name             TEXT NOT NULL,
    nationality      TEXT,
    url              TEXT
);

-- ================================================
-- DRIVERS
-- ================================================
CREATE TABLE IF NOT EXISTS pl1final.drivers (
    driver_id       INTEGER PRIMARY KEY,
    driver_ref      TEXT,
    number          INTEGER,
    code            TEXT,
    forename        TEXT,
    surname         TEXT,
    dob             DATE,
    nationality     TEXT,
    url             TEXT
);

-- ================================================
-- STATUS
-- ================================================
CREATE TABLE IF NOT EXISTS pl1final.status (
    status_id   INTEGER PRIMARY KEY,
    status      TEXT
);

-- ================================================
-- RACES
-- ================================================
CREATE TABLE IF NOT EXISTS pl1final.races (
    race_id         INTEGER PRIMARY KEY,
    year            INTEGER,
    round           INTEGER,
    circuit_id      INTEGER,
    name            TEXT,
    date            DATE,
    time            TEXT,
    url             TEXT,
    fp1_date        DATE,
    fp1_time        TEXT,
    fp2_date        DATE,
    fp2_time        TEXT,
    fp3_date        DATE,
    fp3_time        TEXT,
    quali_date      DATE,
    quali_time      TEXT,
    sprint_date     DATE,
    sprint_time     TEXT,
    CONSTRAINT fk_races_circuit
        FOREIGN KEY (circuit_id)
        REFERENCES pl1final.circuits(circuit_id)
);

-- ================================================
-- RESULTS
-- ================================================
CREATE TABLE IF NOT EXISTS pl1final.results (
    result_id              INTEGER PRIMARY KEY,
    race_id                INTEGER,
    driver_id              INTEGER,
    constructor_id         INTEGER,
    number                 INTEGER,
    grid                   INTEGER,
    position               INTEGER,
    position_text          TEXT,
    position_order         INTEGER,
    points                 REAL,
    laps                   INTEGER,
    time                   TEXT,
    milliseconds           INTEGER,
    fastest_lap            INTEGER,
    rank                   INTEGER,
    fastest_lap_time       TEXT,
    fastest_lap_speed      REAL,
    status_id              INTEGER,
    CONSTRAINT fk_results_race
        FOREIGN KEY (race_id)
        REFERENCES pl1final.races(race_id),
    CONSTRAINT fk_results_driver
        FOREIGN KEY (driver_id)
        REFERENCES pl1final.drivers(driver_id),
    CONSTRAINT fk_results_constructor
        FOREIGN KEY (constructor_id)
        REFERENCES pl1final.constructors(constructor_id),
    CONSTRAINT fk_results_status
        FOREIGN KEY (status_id)
        REFERENCES pl1final.status(status_id)
);

-- ================================================
-- QUALIFYING
-- ================================================
CREATE TABLE IF NOT EXISTS pl1final.qualifying (
    qualify_id      INTEGER PRIMARY KEY,
    race_id         INTEGER,
    driver_id       INTEGER,
    constructor_id  INTEGER,
    number          INTEGER,
    position        INTEGER,
    q1              TEXT,
    q2              TEXT,
    q3              TEXT,
    CONSTRAINT fk_qualifying_race
        FOREIGN KEY (race_id)
        REFERENCES pl1final.races(race_id),
    CONSTRAINT fk_qualifying_driver
        FOREIGN KEY (driver_id)
        REFERENCES pl1final.drivers(driver_id),
    CONSTRAINT fk_qualifying_constructor
        FOREIGN KEY (constructor_id)
        REFERENCES pl1final.constructors(constructor_id)
);

-- ================================================
-- LAP_TIMES
-- ================================================
CREATE TABLE IF NOT EXISTS pl1final.lap_times (
    race_id         INTEGER,
    driver_id       INTEGER,
    lap             INTEGER,
    position        INTEGER,
    time            TEXT,
    milliseconds    INTEGER,
    PRIMARY KEY (race_id, driver_id, lap),
    CONSTRAINT fk_lap_times_race
        FOREIGN KEY (race_id)
        REFERENCES pl1final.races(race_id),
    CONSTRAINT fk_lap_times_driver
        FOREIGN KEY (driver_id)
        REFERENCES pl1final.drivers(driver_id)
);

-- ================================================
-- PIT_STOPS
-- ================================================
CREATE TABLE IF NOT EXISTS pl1final.pit_stops (
    race_id         INTEGER,
    driver_id       INTEGER,
    stop            INTEGER,
    lap             INTEGER,
    time            TEXT,
    duration        TEXT,
    milliseconds    INTEGER,
    PRIMARY KEY (race_id, driver_id, stop),
    CONSTRAINT fk_pit_stops_race
        FOREIGN KEY (race_id)
        REFERENCES pl1final.races(race_id),
    CONSTRAINT fk_pit_stops_driver
        FOREIGN KEY (driver_id)
        REFERENCES pl1final.drivers(driver_id),
    CONSTRAINT fk_pit_stops_lap
        FOREIGN KEY (race_id, driver_id, lap)
        REFERENCES pl1final.lap_times(race_id, driver_id, lap)
);

-- ================================================
-- SEASONS
-- ================================================
CREATE TABLE IF NOT EXISTS pl1final.seasons (
    year    INTEGER PRIMARY KEY,
    url     TEXT
);






\echo 'Cargando la tabla drivers'
INSERT INTO pl1final.drivers (driver_id, driver_ref, number, code, forename, surname, dob, nationality, url)
SELECT DISTINCT ON (driverRef)
    driverId::INTEGER,
    driverRef,
    number::INTEGER,
    code,
    forename,
    surname,
    dob::DATE,
    nationality,
    url
FROM ddbb.drivers;


\echo 'Cargando la tabla circuits'
INSERT INTO pl1final.circuits (circuit_id, circuit_ref, name, location, country, lat, lng, alt, url)
SELECT DISTINCT ON (circuitRef)
    circuitId::INTEGER,
    circuitRef,
    name,
    location,
    country,
    lat::REAL,
    lng::REAL,
    alt::INTEGER,
    url
FROM ddbb.circuits;


\echo 'Cargando la tabla constructors'
INSERT INTO pl1final.constructors (constructor_id, constructor_ref, name, nationality, url)
SELECT DISTINCT ON (constructorRef)
    constructorId::INTEGER,
    constructorRef,
    name,
    nationality,
    url
FROM ddbb.constructors;


\echo 'Cargando la tabla races'
INSERT INTO pl1final.races (race_id, year, round, circuit_id, name, date, time, url,
    fp1_date, fp1_time, fp2_date, fp2_time, fp3_date, fp3_time,
    quali_date, quali_time, sprint_date, sprint_time)
SELECT DISTINCT ON (raceId)
    raceId::INTEGER,
    year::INTEGER,
    round::INTEGER,
    circuitId::INTEGER,
    name,
    date::DATE,
    time,
    url,
    fp1_date::DATE,
    fp1_time,
    fp2_date::DATE,
    fp2_time,
    fp3_date::DATE,
    fp3_time,
    quali_date::DATE,
    quali_time,
    sprint_date::DATE,
    sprint_time
FROM ddbb.races;


\echo 'Cargando la tabla status'
INSERT INTO pl1final.status (status_id, status)
SELECT DISTINCT ON (statusId)
    statusId::INTEGER,
    status
FROM ddbb.status;


\echo 'Cargando la tabla results'
INSERT INTO pl1final.results (result_id, race_id, driver_id, constructor_id, number, grid, position,
    position_text, position_order, points, laps, time, milliseconds,
    fastest_lap, rank, fastest_lap_time, fastest_lap_speed, status_id)
SELECT DISTINCT ON (resultados_id)
    resultados_id::INTEGER,
    gpid::INTEGER,
    pilotoid::INTEGER,
    escuderiaid::INTEGER,
    número::INTEGER,
    pos_parrilla::INTEGER,
    posición::INTEGER,
    posicióntexto,
    posiciónorden::INTEGER,
    puntos::REAL,
    vueltas::INTEGER,
    tiempo,
    tiempomilsgs::INTEGER,
    vueltarápida::INTEGER,
    puesto_campeonato::INTEGER,
    vueltarápida_tiempo,
    vueltarápida_velocidad::REAL,
    estadoid::INTEGER
FROM ddbb.results;


\echo 'Cargando la tabla qualifying'
INSERT INTO pl1final.qualifying (qualify_id, race_id, driver_id, constructor_id, number, position, q1, q2, q3)
SELECT DISTINCT ON (qualifyId)
    qualifyId::INTEGER,
    raceId::INTEGER,
    driverId::INTEGER,
    constructorId::INTEGER,
    number::INTEGER,
    position::INTEGER,
    q1, q2, q3
FROM ddbb.qualifying;


\echo 'Cargando la tabla lap_times'
INSERT INTO pl1final.lap_times (race_id, driver_id, lap, position, time, milliseconds)
SELECT DISTINCT ON (raceId, driverId, lap)
    raceId::INTEGER,
    driverId::INTEGER,
    lap::INTEGER,
    position::INTEGER,
    time,
    milliseconds::INTEGER
FROM ddbb.lap_times;


\echo 'Cargando la tabla pit_stops'
INSERT INTO pl1final.pit_stops (race_id, driver_id, stop, lap, time, duration, milliseconds)
SELECT DISTINCT ON (raceId, driverId, stop)
    raceId::INTEGER,
    driverId::INTEGER,
    stop::INTEGER,
    lap::INTEGER,
    time,
    duration,
    milliseconds::INTEGER
FROM ddbb.pit_stops;


\echo 'Cargando la tabla seasons'
INSERT INTO pl1final.seasons (year, url)
SELECT DISTINCT ON (year)
    year::INTEGER,
    url
FROM ddbb.seasons;




-- CONSULTA 1
-- SELECT * FROM pl1final.circuits JOIN pl1final.races ON pl1final.circuits.circuit_id = pl1final.races.circuit_id WHERE pl1final.races.name LIKE '%Grand Prix%' ;
-- SELECT pl1final.circuits.name, count(*) AS totalCarreras 
-- FROM pl1final.circuits 
-- JOIN pl1final.races ON pl1final.circuits.circuit_id = pl1final.races.circuit_id 
-- WHERE pl1final.races.name LIKE '%Grand Prix%'
-- GROUP BY pl1final.circuits.circuit_id 
-- ORDER BY totalCarreras DESC;

-- CONSULTA 2 (A MEDIAS)
SELECT pl1final.drivers.forename, SUM(pl1final.results.points) AS gpSenna 
FROM pl1final.drivers 
JOIN pl1final.results ON pl1final.drivers.driver_id = pl1final.results.driver_id 
WHERE pl1final.drivers.surname = 'Senna' AND pl1final.drivers.forename = 'Ayrton' 
GROUP BY pl1final.drivers.forename 
ORDER BY gpSenna DESC;




\echo "Mostrar cuantas circuits hay" 
SELECT count(*) as Número_de_circuits FROM ddbb.circuits;

-- \echo "Mostrar las circuits en país específico" 
-- SELECT * FROM ddbb.circuits WHERE country='Spain';

-- \echo "Mostrar cuantas constructors hay" 
-- SELECT count(*) as Número_de_constructors FROM ddbb.constructors;

-- \echo "Mostrar las constructors en país específico" 
-- SELECT * FROM ddbb.constructors WHERE nationality='Spanish';

-- \echo "Mostrar cuantas drivers hay" 
-- SELECT count(*) as Número_de_drivers FROM ddbb.drivers;

-- \echo "Mostrar las drivers en país específico" 
-- SELECT * FROM ddbb.drivers WHERE nationality='Spanish';

-- \echo "Mostrar cuantas lap_times hay" 
-- SELECT count(*) as Número_de_lap_times FROM ddbb.lap_times;

-- \echo "Mostrar las lap_times de un driver específico" 
-- SELECT * FROM ddbb.lap_times WHERE driverId='1';

-- \echo "Mostrar cuantas pit_stops hay" 
-- SELECT count(*) as Número_de_pit_stops FROM ddbb.pit_stops;

-- \echo "Mostrar las pit_stops de un driver específico" 
-- SELECT * FROM ddbb.pit_stops WHERE driverId='1';

-- \echo "Mostrar cuantas qualifying hay" 
-- SELECT count(*) as Número_de_qualifying FROM ddbb.qualifying;

-- \echo "Mostrar las qualifying de un driver específico" 
-- SELECT * FROM ddbb.qualifying WHERE driverId='1';

-- \echo "Mostrar cuantas races hay" 
-- SELECT count(*) as Número_de_races FROM ddbb.races;

-- \echo "Mostrar las races de un año específico" 
-- SELECT * FROM ddbb.races WHERE year='2009';

-- \echo "Mostrar cuantas results hay" 
-- SELECT count(*) as Número_de_results FROM ddbb.results;

-- \echo "Mostrar las results de un piloto específico" 
-- SELECT * FROM ddbb.results WHERE pilotoid='1';

-- \echo "Mostrar cuantas seasons hay" 
-- SELECT count(*) as Número_de_seasons FROM ddbb.seasons;

-- \echo "Mostrar las seasons de un año específico" 
-- SELECT * FROM ddbb.seasons WHERE year='2009';

-- \echo "Mostrar cuantas status hay" 
-- SELECT count(*) as Número_de_status FROM ddbb.status;

-- \echo "Mostrar las status 'Finished'" 
-- SELECT * FROM ddbb.status WHERE status='Finished';

ROLLBACK;  -- importante! permite correr el script múltiples veces