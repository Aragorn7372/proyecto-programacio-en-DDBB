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
Descripción: Un trigger que impide insertar o actualizar azafatos con edad menor a 18 o mayor a 65 años.
Requisitos cubiertos:
Cancelación: Rechazar operación si la edad no es válida.
Estructuras condicionales: Verificar rango de edad.*/

/* 4. Procedimiento: Generar Reporte de Vuelos por Fecha
Descripción: Un procedimiento que lista todos los vuelos en un rango de fechas, incluyendo origen, destino y número de pasajeros.

Requisitos cubiertos:

Parámetros: fecha_inicio, fecha_fin.

Cursores: Recorrer vuelos y contar pasajeros.

Estructuras iterativas: Filtrar por fechas.*/

/* 5. Función: Verificar Disponibilidad de Pista
Descripción: Una función que verifica si una pista en un aeropuerto (lugar) está disponible para un horario específico, evitando solapamientos.

Requisitos cubiertos:

Parámetros: codigo_lugar, hora_salida, hora_llegada.

Cursores: Consultar vuelos existentes en ese lugar.

Cancelación: Retornar falso si hay conflicto.*/

/* 6. Disparador: Actualizar Antigüedad Automáticamente
Descripción: Un trigger que actualiza la antigüedad de un empleado (en días) cada vez que se modifica su fecha de contrato.

Requisitos cubiertos:

Estructuras condicionales: Verificar cambios en fecha_contrato.

Manejadores: Gestionar errores en la actualización.*/