-- Se crea la tabla auditoria con los atributos dados en el enunciado
-- --CREATE TABLE auditoria (
-- nombretabla text,
-- fecha timestamp
-- ..etc.
-- --);
--Se crea la función que se ejecutará

CREATE TABLE f1.auditoria (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tipo_evento TEXT,
    nombre_tabla TEXT,
    usuario TEXT,
    fecha TIMESTAMP
);


CREATE OR REPLACE FUNCTION fn_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO f1.auditoria(tipo_evento, nombre_tabla, usuario, fecha)
        VALUES ('alta', TG_TABLE_NAME, current_user, CURRENT_TIMESTAMP);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO f1.auditoria(tipo_evento, nombre_tabla, usuario, fecha)
        VALUES ('modificación', TG_TABLE_NAME, current_user, CURRENT_TIMESTAMP);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO f1.auditoria(tipo_evento, nombre_tabla, usuario, fecha)
        VALUES ('borrado', TG_TABLE_NAME, current_user, CURRENT_TIMESTAMP);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--Se crea el trigger que se dispara cuando hay una inserción, modificación o borrado en cada tabla de la base de datos discos
 
 
CREATE TRIGGER tg_auditoria_pilotos AFTER INSERT OR UPDATE OR DELETE
    ON f1.pilotos FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_escuderias AFTER INSERT OR UPDATE OR DELETE
    ON f1.escuderias FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_circuitos AFTER INSERT OR UPDATE OR DELETE
    ON f1.circuitos FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_gps AFTER INSERT OR UPDATE OR DELETE
    ON f1.gps FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_pcgps AFTER INSERT OR UPDATE OR DELETE
    ON f1.pilotos_corren_gps FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_pca AFTER INSERT OR UPDATE OR DELETE
    ON f1.pilotos_califican_gps FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_pcvg AFTER INSERT OR UPDATE OR DELETE
    ON f1.pilotos_corren_vueltas_gps FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_prpg AFTER INSERT OR UPDATE OR DELETE
    ON f1.pilotos_realizan_paradas_gps FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();

CREATE TRIGGER tg_auditoria_temporadas AFTER INSERT OR UPDATE OR DELETE
    ON f1.temporadas FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();


--Lo mismo para cada tabla