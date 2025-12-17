-- Un trigger que se dispare cuando se inserta una nueva carrera de un piloto.
-- En primer lugar, se creará una tabla donde se contabiliza el número total
-- de puntos de cada piloto, esta tabla se actualizará después de que se
-- inserten los resultados de una determinada carrera con los puntos
-- conseguidos por cada piloto en la misma





------------------------------------------------------------
--TRIGGER: actualizar puntos totales por piloto
------------------------------------------------------------

\echo 'Creando tabla de puntos totales por piloto'
CREATE TABLE IF NOT EXISTS f1.puntos_totales (
    pilotoref TEXT PRIMARY KEY,
    puntos_totales INT DEFAULT 0
);

-- Carga inicial
INSERT INTO f1.puntos_totales (pilotoref, puntos_totales)
SELECT pilotoref, SUM(puntos)
FROM f1.pilotos_corren_gps
GROUP BY pilotoref;




\echo 'Creando función del trigger para sumar puntos'
CREATE OR REPLACE FUNCTION f1.actualizar_puntos_piloto()
RETURNS TRIGGER AS $$
BEGIN

    -- Se intenta actualizar puntos de piloto existente
    UPDATE f1.puntos_totales
    SET puntos_totales = puntos_totales + NEW.puntos
    WHERE pilotoref = NEW.pilotoref;

    -- Si no existía, se inserta con los puntos nuevos
    IF NOT FOUND THEN
        INSERT INTO f1.puntos_totales(pilotoref, puntos_totales)
        VALUES (NEW.pilotoref, NEW.puntos);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger que actualiza puntos después de cada insert en pilotos_corren_gps:
CREATE TRIGGER trg_actualizar_puntos_piloto
AFTER INSERT ON f1.pilotos_corren_gps
FOR EACH ROW
EXECUTE FUNCTION f1.actualizar_puntos_piloto();


