/* 1. Procedimiento: Asignar Piloto a Vuelo
Descripción: Un procedimiento que asigna un piloto y su copiloto a un vuelo específico, verificando que ambos estén
disponibles y sean pilotos (no azafatos).
Requisitos cubiertos:
Parámetros: dni_piloto, dni_copiloto, codigo_vuelo.
Estructuras condicionales: Verificar que los empleados sean pilotos.
Cancelación: Si no cumplen los requisitos, cancelar la operación. */

DELIMITER &&

CREATE OR REPLACE PROCEDURE asignar_piloto_a_vuelo(
    IN dni_piloto CHAR(9),
    IN dni_copiloto CHAR(9),
    IN codigo_vuelo INT
)
BEGIN
    DECLARE es_piloto INT;
    DECLARE es_copiloto INT;
    DECLARE vuelo_existe INT;

    -- Verificar si el vuelo existe
    SET vuelo_existe = (SELECT COUNT(*) FROM vuelos WHERE código = codigo_vuelo);

    IF vuelo_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El vuelo especificado no existe';
    END IF;

    -- Verificar si el dni_piloto es realmente un piloto
    SET es_piloto = (SELECT COUNT(*) FROM empleados
    WHERE dni = dni_piloto AND tipo = 'Piloto');

    -- Verificar si el dni_copiloto es realmente un piloto
    SET es_copiloto = (SELECT COUNT(*) FROM empleados
    WHERE dni = dni_copiloto AND tipo = 'Piloto');

    IF es_piloto = 0 OR es_copiloto = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Uno o ambos empleados no son pilotos';
    END IF;
        -- Insertar en la tabla piloto si no existe ya
        INSERT INTO piloto (dni, dni_copiloto, numero_vuelos)
        VALUES (dni_piloto, dni_copiloto, 0)
        ON DUPLICATE KEY UPDATE dni_copiloto = dni_copiloto;

        -- Asignar el piloto al vuelo
        INSERT INTO tiene (dni, código)
        VALUES (dni_piloto, codigo_vuelo);

        -- Asignar el copiloto al vuelo
        INSERT INTO tiene (dni, código)
        VALUES (dni_copiloto, codigo_vuelo);

        SELECT 'Piloto y copiloto asignados correctamente al vuelo' AS Resultado;

END&&

DELIMITER ;

-- COMPROBACIONES --

-- Prueba exitosa (empleados son pilotos)
CALL asignar_piloto_a_vuelo('87333555P', '52115920r', 1);

-- Prueba fallida (uno no es piloto)
CALL asignar_piloto_a_vuelo('91346111b', '52115920r', 1);

-- Verificar resultados
SELECT * FROM piloto WHERE dni = '87333555P';
SELECT * FROM tiene WHERE código = 1 AND dni IN ('87333555P', '52115920r');

/* 2. Función: Calcular Ingresos por Vuelo
Descripción: Una función que calcula los ingresos estimados de un vuelo basado en el número de pasajeros y un precio base.
Requisitos cubiertos:
Parámetros: codigo_vuelo, precio_base.
Cursores: Contar pasajeros en el vuelo.
Estructuras iterativas: Sumar ingresos si hay pasajeros.*/

DELIMITER $$

CREATE FUNCTION calcular_ingresos_vuelo(codigo_vuelo INT, precio_base DECIMAL(10,2))
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE num_pasajeros INT;
    DECLARE ingresos DECIMAL(10,2);

-- Contar pasajeros en el vuelo

SET num_pasajeros = (SELECT COUNT(*) FROM embarcar
                    WHERE código = codigo_vuelo);

-- Calcular ingresos
IF num_pasajeros > 0 THEN
    SET ingresos = num_pasajeros * precio_base;
ELSE
    SET ingresos = 0;
END IF;

RETURN ingresos;
END$$

DELIMITER ;

-- COMPROBACIONES --

-- Ver cuántos pasajeros tiene el vuelo 14
SELECT COUNT(*) AS Numero_pasajeros FROM embarcar WHERE código = 14;

-- Calcular ingresos con precio base de 150
SELECT calcular_ingresos_vuelo(14, 150.00) AS Ingresos_estimados;

-- Probar con vuelo sin pasajeros (usar un código sin pasajeros)
SELECT calcular_ingresos_vuelo(99, 150.00) AS Ingresos_estimados;

/* 3. Disparador: Validar Edad de Azafatos
Descripción: Un trigger que impide insertar azafatos con edad menor a 18 o mayor a 65 años.
Requisitos cubiertos:
Cancelación: Rechazar operación si la edad no es válida.
Estructuras condicionales: Verificar rango de edad.*/
    DELIMITER $$
    CREATE OR REPLACE TRIGGER verificacion_edad BEFORE INSERT ON azafatos
    FOR EACH ROW
    BEGIN
        IF(NEW.edad>65 OR NEW.edad<18)THEN
            SIGNAL SQLSTATE  '45000'
            SET MESSAGE_TEXT = 'edad no valida debe estar entre los 18 y 65';
        end if;
    end$$
/*pruebas de funcionalidad*/
-- azafato con edad correcta --
    INSERT empleados VALUES ('55555555k','prueba','buena',CURRENT_DATE(),100.25,'Azafatos');
    INSERT azafatos values ('55555555k','H',18);
    /* El SELECT no deberia fallar*/
    SELECT * from azafatos where dni='55555555k';
    /*limpieza de datos*/
    delete from azafatos where dni='55555555k';
-- azafato con edad superior correcta --
    INSERT azafatos values ('55555555k','H',65);
    /*El SELECT no deberia mostrar los datos anteriormente creados*/
    SELECT * from azafatos where dni='55555555k';
    /*limpieza de datos*/
    delete from azafatos where dni='55555555k';
-- azafato con edad incorrecta inferior --
    INSERT azafatos values ('55555555k','H',17);
    /*los select no muestran nada debido a que no existen esas columnas porque el trigger las elimina y cancela la creacion de azafatos*/
    SELECT * from azafatos where dni='55555555k';
-- azafato con edad incorrecta superior --
    INSERT azafatos values ('55555555k','H',66);
    /*los select deberian dar error debido a que no existen esas columnas porque el trigger las elimina y cancela la creacion de azafatos*/
    SELECT * from azafatos where dni='55555555k';
    /*Limpieza de datos*/
    delete from empleados where dni='55555555k';

/* 4. Procedimiento: Generar Reporte de Vuelos por Fecha
Descripción: Un procedimiento que lista todos los vuelos en un rango de fechas, incluyendo origen, destino y número de pasajeros.

Requisitos cubiertos:

Parámetros: fecha_inicio, fecha_fin.

Estructuras iterativas: Filtrar por fechas.*/

CREATE OR REPLACE PROCEDURE  reporte_vuelos_por_fecha(
    IN fecha_inicio DATE,
    IN fecha_fin DATE
)
BEGIN
    SELECT
        v.código AS codigo,
        v.fecha AS Fecha,
        v.numero_vuelo AS Número_Vuelo,
        v.hora_salida AS Hora_Salida,
        v.hora_llegada AS Hora_Llegada,
        CONCAT(lo.localidad, ', ', lo.pais) AS Origen,
        CONCAT(ld.localidad, ', ', ld.pais) AS Destino,
        COUNT(e.dni) AS Pasajeros
    FROM vuelos v
             JOIN lugar lo ON v.código_origen = lo.código
             JOIN lugar ld ON v.código_destino = ld.código
             LEFT JOIN embarcar e ON v.código = e.código
    WHERE v.fecha BETWEEN fecha_inicio AND fecha_fin
    GROUP BY
        v.código, v.fecha, v.numero_vuelo, v.hora_salida, v.hora_llegada,
        lo.localidad, lo.pais,
        ld.localidad, ld.pais;
END $$
    /*deberian aparecer solo las columnas dentro de esas fechas, que deberian ser 9 */
 CALL reporte_vuelos_por_fecha('2024-02-05','2024-05-19');

SELECT * FROM vuelos WHERE fecha BETWEEN('2024-02-05')AND '2024-05-19';


/* 5. Función: Verificar Disponibilidad de Pista
Descripción: Una función que verifica si una pista en un aeropuerto (lugar) está disponible para un horario específico, evitando solapamientos.
Requisitos cubiertos:
Parámetros: codigo_lugar, hora_salida, hora_llegada.
Cursores: Consultar vuelos existentes en ese lugar.
Cancelación: Retornar falso si hay conflicto.*/

DELIMITER $$

CREATE FUNCTION verificar_disponibilidad_pista(
    codigo_lugar INT,
    hora_salida TIME,
    hora_llegada TIME
) RETURNS BOOLEAN
BEGIN
    DECLARE disponibilidad INT DEFAULT 0;

    -- Verificar solapamiento con vuelos existentes

    SELECT COUNT(*) INTO disponibilidad
    FROM vuelos
    WHERE (código_origen = codigo_lugar OR código_destino = codigo_lugar)
    AND (
        (hora_salida < hora_llegada AND hora_llegada > hora_salida)
    );

    RETURN (disponibilidad = 0);
END$$

DELIMITER ;

 -- Prueba de disponibilidad

SELECT verificar_disponibilidad_pista(1, '10:00:00', '12:00:00') AS Disponible;

SELECT verificar_disponibilidad_pista(2, '15:00:00', '16:30:00') AS Disponible;

/* 6. Disparador: Actualizar Antigüedad Automáticamente
Descripción: Un trigger que actualiza la antigüedad de un empleado (en días) cada vez que se modifica su fecha de contrato.
Requisitos cubiertos:
Estructuras condicionales: Verificar cambios en fecha_contrato.
Manejadores: Gestionar errores en la actualización.*/

ALTER TABLE empleados ADD COLUMN antigüedad INT;

DELIMITER $$

CREATE TRIGGER actualizar_antiguedad
BEFORE UPDATE ON empleados
FOR EACH ROW
BEGIN
    IF OLD.fecha_contrato != NEW.fecha_contrato THEN
        SET NEW.antigüedad = DATEDIFF(CURDATE(), NEW.fecha_contrato);
    END IF;
END$$

CREATE TRIGGER calcular_antiguedad_insert
BEFORE INSERT ON empleados
FOR EACH ROW
BEGIN
    SET NEW.antigüedad = DATEDIFF(CURDATE(), NEW.fecha_contrato);
END$$

DELIMITER ;


-- Pruebas
UPDATE empleados SET fecha_contrato = '2023-01-01' WHERE dni = '87333555P';

SELECT antigüedad FROM empleados WHERE dni = '87333555P';