# Consultas SQL Avanzadas — Gestión de Alojamientos Turísticos

## Motor utilizado

* PostgreSQL
* Base de datos: `accommodations_tourism`

## Descripción

Este repositorio contiene el archivo `consultas_sql.sql`, el cual incluye 20 consultas SQL funcionales sobre una base de datos de gestión de alojamientos turísticos.

Las consultas desarrolladas incluyen operaciones CRUD, filtros con `SELECT`, actualizaciones con `UPDATE`, eliminación segura con `DELETE`, consultas con `INNER JOIN`, `LEFT JOIN`, funciones de agregación, `GROUP BY`, `HAVING` y subconsultas.

## Archivo principal

* `consultas_sql.sql`

## Esquema principal

La base de datos contiene tablas relacionadas con propietarios, alojamientos, ubicaciones, tipos de alojamiento, habitaciones, huéspedes, reservas, pagos y reseñas.

Tablas principales:

* `owners`
* `accommodations`
* `accommodation_types`
* `locations`
* `rooms`
* `guests`
* `bookings`
* `booking_statuses`
* `payments`
* `reviews`

## Consultas desarrolladas

1. Insertar propietario
2. Insertar alojamiento
3. Registrar huésped y reserva
4. Insertar pago
5. Consultar alojamientos activos
6. Consultar huéspedes por país
7. Consultar reservas por fechas
8. Actualizar precio
9. Actualizar estado de reserva
10. Eliminar reseña
11. JOIN reservas + huésped
12. JOIN alojamiento completo
13. JOIN pagos + reservas
14. LEFT JOIN alojamientos sin reseñas
15. LEFT JOIN alojamientos sin reservas
16. Total de ingresos con `SUM`
17. Promedio de rating con `AVG`
18. Top alojamientos con `COUNT` y `LIMIT`
19. Alojamientos con más de 3 reservas usando `HAVING`
20. Alojamiento más caro usando subconsulta

## Evidencia

La evidencia se presenta mediante capturas de pantalla de la ejecución de cada consulta en PostgreSQL.
