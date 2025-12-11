
import sys
import psycopg2
import pytest

class portException(Exception): pass

def menu():
    print("""
    1. Haga un listado de todos los circuitos, así cómo el número de grandes premios
    que ha albergado cada uno. El listado estará ordenado del circuito que haya
    acogido más carreras al que menos
    2. Muestre el número de grandes premios que ha corrido Ayrton Senna así cómo el
    total de puntos conseguidos en las mismas
    3. Haga un listado con el nombre y apellidos de todos los pilotos nacidos después
    del 31 de diciembre de 1999, junto con el número de carreras en las que haya
    participado cada uno de ellos
    4. Muestre el nombre de todas las escuderías españolas o italianas junto con el
    número de grandes premios corridos
    NO EJECUTAR -> 5. Crea una vista donde para cada temporada se muestren los pilotos que han corrido
    en la misma, así como los puntos totales que han obtenido cada uno en esa
    temporada.
    6. Utilizando dicha vista obtén el nombre de los pilotos ganadores en las temporadas
    del 2010 al 2015 inclusive
    7. Obtener el nombre de los pilotos que han ganado al menos un GP (posición = 1)
    8. Mostrar el número de Grandes Premios por país
    9. Mostrar el piloto con la vuelta más rápida en toda la historia (Se prohíbe el uso de
    la sentencia LIMIT)
    10. Mostrar el número de paradas en boxes por piloto en el gran premio de Monaco
    de 2023
    11. Mostrar el nombre de los pilotos que hayan participado en más de 100 premios
    ordenados por aquellos que hayan participado en más grandes premios""")


def ask_port(msg):
    """
        ask for a valid TCP port
        ask_port :: String -> IO Integer | Exception
    """
    try:                                                                        # try
        answer  = input(msg)                                                    # pide el puerto
        port    = int(answer)                                                   # convierte a entero
        if (port < 1024) or (port > 65535):                                     # si el puerto no es valido
            raise ValueError                                                    # lanza una excepción
        else:
            return port
    except ValueError:     
        raise portException                                                     # raise portException
    #finally:                                                                    # finally
    #    return port                                                             # return port

def ask_conn_parameters():
    """
        ask_conn_parameters:: () -> IO String
        pide los parámetros de conexión
        TODO: cada estudiante debe introducir los valores para su base de datos
    """
    host = 'localhost'                                                          # 
    port = ask_port('TCP port number: ')                                        # pide un puerto TCP
    user = "admin_f1"#input("Introduce el usuario: ")             #'admin_f1'              # TODO
    password = "admin123" #input("Introduce la contraseña del usuario: ")       #'admin123' # TODO
    database = 'f1'                                                             # TODO
    return (host, port, user,
             password, database)

def main():
    """
        main :: () -> IO None
    """
    try:
        (host, port, user, password, database) = ask_conn_parameters()          #
        connstring = f'host={host} port={port} user={user} password={password} dbname={database}' 
        conn    = psycopg2.connect(connstring)                                  #
                                                                               

        consulta = ""
        consultas_prehechas = {
                1: """SELECT ci.nombre, count(*) as nTotal
            FROM f1.circuitos as ci JOIN f1.gps as gps ON ci.circuitoref=gps.circuitoref 
            WHERE gps.nombregp LIKE '%Grand Prix%' 
            GROUP BY ci.circuitoref ORDER BY nTotal desc;""",

                2: """SELECT count(*) as nTotal, SUM(gps.puntos) as puntosTotal
            FROM f1.pilotos as pi JOIN f1.pilotos_corren_gps as gps ON pi.pilotoref=gps.pilotoref
            WHERE pi.nombre='Ayrton' AND pi.apellido='Senna'
            GROUP BY gps.pilotoref ORDER BY nTotal desc;""",

                3: """SELECT 
            p.nombre,
            p.apellido,
            COUNT(pcg.*) AS carreras_disputadas
            FROM 
            f1.pilotos p
            LEFT JOIN 
            f1.pilotos_corren_gps pcg
                ON p.pilotoref = pcg.pilotoref
            WHERE 
            p.f_nacimiento > DATE '1999-12-31'
            GROUP BY 
            p.nombre, p.apellido
            ORDER BY 
            carreras_disputadas DESC;""",

                4: """SELECT e.nombre, COUNT(pcg.*) as gps_corridos
            FROM f1.escuderías e JOIN f1.pilotos_corren_gps pcg ON e.escuderíaref=pcg.escuderiaref
            WHERE e.nacionalidad = 'Spanish' or e.nacionalidad = 'Italian'
            GROUP BY e.nombre, e.nacionalidad
            ORDER BY gps_corridos DESC;""",

            #     5: """CREATE VIEW f1.pilotos_puntos_temporada as
            # SELECT pcg.año, pcg.pilotoref, p.nombre, p.apellido, SUM(pcg.puntos) as puntos_totales
            # FROM f1.pilotos_corren_gps pcg JOIN f1.pilotos p ON pcg.pilotoref=p.pilotoref
            # GROUP BY pcg.año, pcg.pilotoref, p.nombre, p.apellido 
            # ORDER BY pcg.año, puntos_totales DESC;""",

                6: """SELECT año, nombre, apellido, puntos_totales
            FROM f1.pilotos_puntos_temporada ppts
            WHERE año BETWEEN 2010 AND 2015
            AND puntos_totales = (
                SELECT MAX(puntos_totales)
                FROM f1.pilotos_puntos_temporada
                WHERE año = ppts.año
            )
            ORDER BY año;""",

                7: """SELECT DISTINCT p.nombre, p.apellido
            FROM f1.pilotos_corren_gps pcg
            JOIN f1.pilotos p ON pcg.pilotoref = p.pilotoref
            WHERE pcg.posición = 1
            ORDER BY p.apellido, p.nombre;""",

                8: """SELECT c.pais, COUNT(g.nombregp) as numero_gps
            FROM f1.circuitos c JOIN f1.gps g ON c.circuitoref=g.circuitoref
            GROUP BY c.pais
            ORDER BY numero_gps DESC;""",

                9: """SELECT nombre, apellido, pcvg.tiempo
            FROM f1.pilotos_corren_vueltas_gps pcvg JOIN f1.pilotos p ON pcvg.pilotoref=p.pilotoref
            WHERE pcvg.tiempo=(
                SELECT MIN(tiempo)
                FROM f1.pilotos_corren_vueltas_gps pcvg
            );""",

                10: """SELECT nombre, apellido, COUNT(*)
            FROM f1.pilotos_realizan_paradas_gps prpg JOIN f1.pilotos p ON prpg.pilotoref=p.pilotoref
            WHERE prpg.nombregp='Monaco Grand Prix' AND prpg.año=2023
            GROUP BY nombre,apellido;""",

                11: """SELECT p.nombre, p.apellido, COUNT(*) AS n_gps
            FROM f1.pilotos p
            JOIN f1.pilotos_corren_gps pcg ON p.pilotoref = pcg.pilotoref
            GROUP BY p.pilotoref, p.nombre, p.apellido
            HAVING COUNT(*) >= 100
            ORDER BY n_gps DESC;"""
        }

        while(consulta!="exit"):
            modo = int(input("Introduce 1 si quieres elegir una consulta prehecha, 2 si quieres hacerla tú, 3 si quieres introducir, 0 para salir"))
            match modo:
                case 3:
                    consulta = "INSERT INTO f1."
                    consulta += input("tabla (valores)")
                    consulta += " VALUES"
                    consulta += " " + input("valores")
                    consulta += ";"
                case 2:
                    consulta = input("Introduce la consulta SQL a ejecutar: ")           # pide una consulta SQL
                case 1:
                    menu()
                    opcion = int(input("Elige el número de consulta: "))
                    consulta=consultas_prehechas[opcion]
                case 0:
                    consulta="exit"
                    
            cur = conn.cursor()                                                 # instacia un cursor

            query   = consulta  #'SELECT * FROM f1.pilotos'                         # prepara una consulta
            if(consulta!="exit"):
                cur.execute(query)
                if(consulta[0] == "S"):                                                      # ejecuta la consulta
                    for record in cur.fetchall():                                           # fetchall devuelve todas las filas de la consulta
                        print(record)                                                       # imprime las filas
            cur.close                                                               # cierra el cursor
            conn.close                                                              # cierra la conexion
    except portException:
        print("The port is not valid!")
    except KeyboardInterrupt:
        print("Program interrupted by user.")
    finally:
        print("Program finished")

#def prueba_conexion():


if __name__ == "__main__":                                                      # Es el modula principal?
    if '--test' in sys.argv:                                                    # chequea el argumento cmdline buscando el modo test
        import doctest                                                          # importa la libreria doctest
        doctest.testmod()                                                       # corre los tests
    else:                                                                       # else
        main()                                                                  # ejecuta el programa principal
