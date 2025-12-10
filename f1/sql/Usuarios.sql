------------------------------------------------------------
-- CREACIÓN DE USUARIOS Y ASIGNACIÓN DE PERMISOS
------------------------------------------------------------

\echo 'Creando usuarios del sistema F1'

-- Usuario administrador: permisos totales sobre la base de datos
CREATE USER admin_f1 WITH PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE f1 TO admin_f1;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA f1 TO admin_f1;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA f1 TO admin_f1;
GRANT ALL PRIVILEGES ON SCHEMA f1 TO admin_f1;

ALTER DEFAULT PRIVILEGES IN SCHEMA f1 GRANT ALL PRIVILEGES ON TABLES TO admin_f1;






------------------------------------------------------------
-- Usuario gestor: puede insertar, actualizar, borrar y consultar,
-- pero no puede crear o alterar tablas
------------------------------------------------------------

CREATE USER gestor_f1 WITH PASSWORD 'gestor123';

-- Permisos en tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA f1 TO gestor_f1;

-- Permiso para usar el esquema f1
GRANT USAGE ON SCHEMA f1 TO gestor_f1;

ALTER DEFAULT PRIVILEGES IN SCHEMA f1 
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO gestor_f1;




------------------------------------------------------------
-- Usuario analista: sólo puede consultar.
------------------------------------------------------------

CREATE USER analista_f1 WITH PASSWORD 'analista123';

GRANT USAGE ON SCHEMA f1 TO analista_f1;
GRANT SELECT ON ALL TABLES IN SCHEMA f1 TO analista_f1;

ALTER DEFAULT PRIVILEGES IN SCHEMA f1 
GRANT SELECT ON TABLES TO analista_f1;





------------------------------------------------------------
-- Usuario invitado: puede ver resultados, pilotos, grandes premios, escuderías, 
-- circuitos y temporadas pero no puede ver vueltas ni paradas en boxes
------------------------------------------------------------

CREATE USER invitado_f1 WITH PASSWORD 'invitado123';

GRANT USAGE ON SCHEMA f1 TO invitado_f1;

-- Tablas permitidas:
GRANT SELECT ON f1.pilotos TO invitado_f1;
GRANT SELECT ON f1.escuderías TO invitado_f1;
GRANT SELECT ON f1.circuitos TO invitado_f1;
GRANT SELECT ON f1.temporadas TO invitado_f1;
GRANT SELECT ON f1.gps TO invitado_f1;
GRANT SELECT ON f1.pilotos_corren_gps TO invitado_f1;
GRANT SELECT ON f1.pilotos_califican_gps TO invitado_f1;

-- Tablas NO permitidas: 
REVOKE ALL ON f1.pilotos_corren_vueltas_gps FROM invitado_f1;
REVOKE ALL ON f1.pilotos_realizan_paradas_gps FROM invitado_f1;

\echo 'Usuarios y permisos creados correctamente'
