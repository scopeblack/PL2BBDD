-- Se crea la tabla auditoria con los atributos dados en el enunciado
-- --CREATE TABLE auditoria (
-- nombretabla text,
-- fecha timestamp
-- ..etc.
-- --);
--Se crea la función que se ejecutará
CREATE OR REPLACE FUNCTION fn_auditoria() RETURNS TRIGGER AS $fn_auditoria$
DECLARE
--no declaro nada porque no me hace falta...de hecho DECLARE podría haberlo omitido en este caso
BEGIN
--Se determina qué acción ha activado el trigger y se inserta un nuevo valor en la tabla dependiendo
--de dicha acción. Junto con la acción se escribe lo que solicita el enunciado
IF TG_OP='INSERT' THEN
    INSERT INTO auditoria VALUES ('alta',TG_table_name,TG_OP,current_user,current_timestamp); --Cuando hay una inserción
ELSIF TG_OP='UPDATE' THEN
    INSERT INTO auditoria VALUES ('modificación',TG_table_name,TG_OP,current_user,current_timestamp); --Cuando hay una modificación
ELSIF TG_OP='DELETE' THEN
    INSERT INTO auditoria VALUES ('borrado',TG_table_name,TG_OP,current_user,current_timestamp); --Cuando hay un borrado
 END IF;
 RETURN NULL;
END;
$fn_auditoria$ LANGUAGE plpgsql;
--Se crea el trigger que se dispara cuando hay una inserción, modificación o borrado en cada tabla de la base de datos discos
CREATE TRIGGER tg_auditoria after INSERT or UPDATE or DELETE
    ON f1.escuderías FOR EACH ROW
    EXECUTE PROCEDURE fn_auditoria();
--Lo mismo para cada tabla