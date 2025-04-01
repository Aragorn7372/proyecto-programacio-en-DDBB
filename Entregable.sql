/* 1. Procedimiento: Asignar Piloto a Vuelo
Descripción: Un procedimiento que asigna un piloto y su copiloto a un vuelo específico, verificando que ambos estén disponibles y sean pilotos (no azafatos).

Requisitos cubiertos:

Parámetros: dni_piloto, dni_copiloto, codigo_vuelo.

Estructuras condicionales: Verificar que los empleados sean pilotos.

Cancelación: Si no cumplen los requisitos, cancelar la operación. */

/* 2. Función: Calcular Ingresos por Vuelo
Descripción: Una función que calcula los ingresos estimados de un vuelo basado en el número de pasajeros y un precio base.

Requisitos cubiertos:

Parámetros: codigo_vuelo, precio_base.

Cursores: Contar pasajeros en el vuelo.

Estructuras iterativas: Sumar ingresos si hay pasajeros.*/

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