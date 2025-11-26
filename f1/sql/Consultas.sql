-- 1. Haga un listado de todos los circuitos, así cómo el número de grandes premios
-- que ha albergado cada uno. El listado estará ordenado del circuito que haya
-- acogido más carreras al que menos

--SELECT ci.nombre, count(*) as nTotal
--FROM f1.circuitos as ci JOIN f1.gps as gps ON ci.circuitoref=gps.circuitoref 
--WHERE gps.nombregp LIKE '%Grand Prix%' 
--GROUP BY ci.circuitoref ORDER BY nTotal desc;

-- 2. Muestre el número de grandes premios que ha corrido Ayrton Senna así cómo el
-- total de puntos conseguidos en las mismas

--SELECT count(*) as nTotal, SUM(gps.puntos) as puntosTotal
--FROM f1.pilotos as pi JOIN f1.pilotos_corren_gps as gps ON pi.pilotoref=gps.pilotoref
--WHERE pi.nombre='Ayrton' AND pi.apellido='Senna'
--GROUP BY gps.pilotoref ORDER BY nTotal desc;





-- 3. Haga un listado con el nombre y apellidos de todos los pilotos nacidos después
-- del 31 de diciembre de 1999, junto con el número de carreras en las que haya
-- participado cada uno de ellos

--SELECT 
--    p.nombre,
--    p.apellido,
--    COUNT(pcg.*) AS carreras_disputadas
--FROM 
--    f1.pilotos p
--LEFT JOIN 
--    f1.pilotos_corren_gps pcg
--        ON p.pilotoref = pcg.pilotoref
--WHERE 
--    p.f_nacimiento > DATE '1999-12-31'
--GROUP BY 
--    p.nombre, p.apellido
--ORDER BY 
--    carreras_disputadas DESC;






-- 4. Muestre el nombre de todas las escuderías españolas o italianas junto con el
-- número de grandes premios corridos

--SELECT e.nombre, COUNT(pcg.*) as gps_corridos
--FROM f1.escuderías e JOIN f1.pilotos_corren_gps pcg ON e.escuderíaref=pcg.escuderiaref
--WHERE e.nacionalidad = 'Spanish' or e.nacionalidad = 'Italian'
--GROUP BY e.nombre, e.nacionalidad
--ORDER BY gps_corridos DESC; 





-- 5. Crea una vista donde para cada temporada se muestren los pilotos que han corrido
-- en la misma, así como los puntos totales que han obtenido cada uno en esa
-- temporada.

--CREATE VIEW f1.pilotos_puntos_temporada as
--SELECT pcg.año, pcg.pilotoref, p.nombre, p.apellido, SUM(pcg.puntos) as puntos_totales
--FROM f1.pilotos_corren_gps pcg JOIN f1.pilotos p ON pcg.pilotoref=p.pilotoref
--GROUP BY pcg.año, pcg.pilotoref, p.nombre, p.apellido 
--ORDER BY pcg.año, puntos_totales DESC;


 
--CREATE VIEW nombre
--SELECT *
--FROM nombre
--LIMIT 10
--F|-#\0 Salida.txt



-- 6. Utilizando dicha vista obtén el nombre de los pilotos ganadores en las temporadas
-- del 2010 al 2015 inclusive


--SELECT año, nombre, apellido, puntos_totales
--FROM f1.pilotos_puntos_temporada ppts
--WHERE año BETWEEN 2010 AND 2015
--  AND puntos_totales = (
--      SELECT MAX(puntos_totales)
--      FROM f1.pilotos_puntos_temporada
--      WHERE año = ppts.año
--  )
--ORDER BY año;







-- 7. Obtener el nombre de los pilotos que han ganado al menos un GP (posición = 1)

--SELECT DISTINCT p.nombre, p.apellido
--FROM f1.pilotos_corren_gps pcg
--    JOIN f1.pilotos p ON pcg.pilotoref = p.pilotoref
--WHERE pcg.posición = 1
--ORDER BY p.apellido, p.nombre;
 

-- 8. Mostrar el número de Grandes Premios por país

--SELECT c.pais, COUNT(g.nombregp) as numero_gps
--FROM f1.circuitos c JOIN f1.gps g ON c.circuitoref=g.circuitoref
--GROUP BY c.pais
--ORDER BY numero_gps DESC;



-- 9. Mostrar el piloto con la vuelta más rápida en toda la historia (Se prohíbe el uso de
-- la sentencia LIMIT)
-- 10. Mostrar el número de paradas en boxes por piloto en el gran premio de Monaco
-- de 2023
-- 11. Mostrar el nombre de los pilotos que hayan participado en más de 100 premios
-- ordenados por aquellos que hayan participado en más grandes premios
