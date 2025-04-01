USE aeropuerto;
-- selecciona el dni de los pasajeros que vuelan con el empleado El Richarz - Victor
SELECT dni FROM pasajeros WHERE dni IN(
    SELECT dni from embarcar where código IN(
        SELECT código FROM vuelos WHERE código IN(
            SELECT código FROM tiene WHERE dni IN(
                SELECT dni FROM empleados WHERE dni LIKE '76200302o'
                )
            )
        )
    )
GROUP BY dni;
-- selecciona los nombres de los pilotos que han tenido como copiloto a Matfied - Victor
SELECT  CONCAT(nombre,' ',apellidos) FROM empleados e JOIN piloto on e.dni = piloto.dni
                                     WHERE dni_copiloto LIKE '81882867D';
-- selecciona toda la informacion de los vuelos no internacionales - Victor
SELECT * FROM vuelos WHERE tipo LIKE  'Nacional';
-- cuenta el total de dinero gastado en los sueldos anualmente - Adri
SELECT SUM(salario) AS Gasto_anual
FROM empleados;
-- selecciona los dnis de los pasajeros en los vuelos con codigo 1 y 3 - Adri
SELECT dni
FROM embarcar
WHERE código IN (1, 3);
-- selecciona al empleado con mayor salario - Adri
SELECT MAX(salario) AS Empleado_Mejor_Pagado
FROM empleados;

-- selecciona los empleados con sueldos mayores a 48000 - Ariel

-- cuenta cuantos pilotos hay en la plantilla -Ariel

-- selecciona a todos los empleados que tengan mas de seis meses de antigüedad - Ariel

-- Selecciona todos los azafatos que sean hombres - Ariel
