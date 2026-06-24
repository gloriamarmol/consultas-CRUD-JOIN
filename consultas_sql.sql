-- ============================================================
-- 01. INSERT - Insertar propietario
-- ============================================================
    INSERT INTO owners (first_name,last_name,company_name,email,phone,tax_id,address_line1,city,
        state,country, postal_code)
    VALUES (
        'Gloria',
        'Marmol',
        'INSAMT Travel Rooms',
        'gloria.marmol.sql@example.com',
        '+503 7000-0000',
        'NIT-SQL-001',
        'Barrio El Centro',
        'San Miguel Tepezontes',
        'La Paz',
        'El Salvador',
        '1601'
    )

-- ============================================================
-- 02. INSERT - Insertar alojamiento
-- Crear un alojamiento vinculado al propietario insertado.
-- ============================================================
WITH datos_base AS (
    SELECT
        o.owner_id,
        at.accommodation_type_id,
        l.location_id
    FROM owners o
    CROSS JOIN accommodation_types at
    CROSS JOIN locations l
    WHERE o.email = 'gloria.marmol.sql@example.com'
      AND at.type_name = 'Apartment'
      AND l.country = 'El Salvador'
    LIMIT 1
),
nuevo_alojamiento AS (
    INSERT INTO accommodations (
        owner_id,
        accommodation_type_id,
        location_id,
        name,
        description,
        max_guests,
        bedroom_count,
        bathroom_count,
        base_price_per_night,
        currency_code,
        check_in_time,
        check_out_time,
        is_active
    )
    SELECT
        owner_id,
        accommodation_type_id,
        location_id,
        'Alojamiento Sin Reservas SQL',
        'Alojamiento creado para la actividad evaluada de consultas SQL.',
        4,
        2,
        1,
        75.00,
        'USD',
        TIME '14:00:00',
        TIME '11:00:00',
        TRUE
    FROM datos_base
    WHERE NOT EXISTS (
        SELECT 1
        FROM accommodations
        WHERE name = 'Alojamiento Sin Reservas SQL'
    )
    RETURNING accommodation_id, owner_id, accommodation_type_id, location_id, name, base_price_per_night, is_active
)
SELECT *
FROM nuevo_alojamiento
UNION ALL
SELECT *
FROM (
    SELECT
        accommodation_id,
        owner_id,
        accommodation_type_id,
        location_id,
        name,
        base_price_per_night,
        is_active
    FROM accommodations
    WHERE name = 'Alojamiento Sin Reservas SQL'
    ORDER BY accommodation_id DESC
    LIMIT 1
) alojamiento_existente
WHERE NOT EXISTS (
    SELECT 1
    FROM nuevo_alojamiento
);


-- ============================================================
-- 03. INSERT - Huésped y reserva
-- Registrar un huésped y una reserva.
-- ============================================================
    INSERT INTO guests (
        first_name,
        last_name,
        email,
        phone,
        date_of_birth,
        nationality,
        passport_number,
        emergency_contact_name,
        emergency_contact_phone
    )
    VALUES (
        'Lucia',
        'Hernandez',
        'lucia.hernandez.sql@example.com',
        '+503 7555-1111',
        DATE '1998-05-14',
        'El Salvador',
        'SVSQL001',
        'Carlos Hernandez',
        '+503 7222-3333'
    );
    
-- ============================================================
-- 04. INSERT - Insertar pago
-- Registrar el pago.
-- ============================================================
   INSERT INTO payments (
        booking_id,
        amount,
        payment_method,
        payment_status,
        payment_date
    )
    values (2,120.00,'Tarjeta','completed', now());

-- ============================================================
-- 05. SELECT - Alojamientos activos
-- Filtrar alojamientos activos.
-- ============================================================
SELECT
    accommodation_id,
    name,
    max_guests,
    bedroom_count,
    bathroom_count,
    base_price_per_night,
    currency_code,
    is_active
FROM accommodations
WHERE is_active = TRUE
ORDER BY accommodation_id;


-- ============================================================
-- 06. SELECT - Huéspedes por país
-- Filtrar huéspedes por nacionalidad.
-- ============================================================
SELECT
    guest_id,
    first_name,
    last_name,
    email,
    nationality
FROM guests
WHERE nationality = 'El Salvador'
ORDER BY guest_id;
-- ============================================================
-- 07. SELECT - Reservas por fechas
-- Uso de BETWEEN para consultar reservas por rango de fecha.
-- ============================================================
SELECT
    booking_id,
    booking_reference,
    guest_id,
    accommodation_id,
    check_in_date,
    check_out_date,
    total_nights,
    total_amount
FROM bookings
WHERE check_in_date BETWEEN DATE '2026-01-01' AND DATE '2026-12-31'
ORDER BY check_in_date, booking_id;


-- ============================================================
-- 08. UPDATE - Actualizar precio
-- Modificar el precio.
-- ============================================================
UPDATE accommodations SET base_price_per_night = 95.00
WHERE accommodation_id = (SELECT accommodation_id FROM accommodations
    WHERE name = 'Alojamiento Sin Reservas SQL'
    ORDER BY accommodation_id DESC
    LIMIT 1
)
RETURNING
    accommodation_id,
    name,
    base_price_per_night,
    updated_at;

-- ============================================================
-- 09. UPDATE - Estado reserva
-- Actualizar el estado de reserva.
-- ============================================================
UPDATE bookings
SET booking_status_id = (
    SELECT booking_status_id
    FROM booking_statuses
    WHERE status_name = 'CheckedIn'
)
WHERE booking_reference = 'BK-STUDENT-001'
RETURNING
    booking_id,
    booking_reference,
    booking_status_id,
    check_in_date,
    check_out_date,
    updated_at;


-- ============================================================
-- 10. DELETE - Eliminar reseña
-- Eliminar where.
-- ============================================================
DELETE FROM reviews
WHERE review_id = 1
RETURNING
    review_id,
    booking_id,
    guest_id,
    accommodation_id,
    rating,
    review_title;
-- ============================================================
-- 11. JOIN - Reservas + huésped
-- INNER JOIN entre reservas y huéspedes.
-- ============================================================
SELECT 
    b.booking_id AS booking_id,
    b.check_in_date AS check_in_date,
    b.check_out_date AS check_out_date,
    b.total_amount AS total_amount,   
    g.first_name AS first_name,       
    g.last_name AS last_name,         
    g.email AS email                  
FROM 
    bookings b
INNER JOIN 
    guests g ON b.guest_id = b.booking_id limit 20;


-- ============================================================
-- 12. JOIN - Alojamiento completo
-- INNER JOIN múltiple.
-- ============================================================
SELECT 
    a.accommodation_id AS accommodation_id,
    a.name AS name,
    a.base_price_per_night AS base_price_per_night,
    t.type_name AS type_name,
    l.city AS city,
    l.country AS country,
    o.first_name AS first_name,
    o.last_name AS last_name,
    o.email AS email,
    am.description AS description
FROM 
    accommodations a
INNER JOIN accommodation_types t ON a.accommodation_type_id = t.accommodation_type_id
INNER JOIN locations l ON a.location_id = l.location_id
INNER JOIN owners o ON a.owner_id = o.owner_id
INNER JOIN accommodation_amenities aa ON a.accommodation_id = aa.accommodation_id
INNER JOIN amenities am ON aa.amenity_id = am.amenity_id limit 10;

-- ============================================================
-- 13. JOIN - Pagos + reservas
-- JOIN combinado entre pagos y reservas.
-- ============================================================
SELECT 
    b.booking_id AS reserva_id,
    b.check_in_date AS fecha_ingreso,
    b.check_out_date AS fecha_salida,
    b.total_amount AS precio_total,
    s.booking_status_id AS estado_reserva,         
    g.first_name AS nombre_huesped,  
    g.last_name AS apellido_huesped,   
    p.payment_id AS pago_id,           
    p.amount AS monto_pagado,         
    p.payment_date AS fecha_pago       
FROM 
    bookings b
LEFT JOIN booking_statuses s ON b.booking_status_id = s.booking_status_id
LEFT JOIN guests g ON b.guest_id = g.guest_id
LEFT JOIN payments p ON b.booking_id = p.booking_id LIMIT 10;


-- ============================================================
-- 14. LEFT JOIN - Alojamientos sin reseñas
-- Incluye registros con NULL en la tabla reviews.
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS alojamiento,
    r.review_id,
    r.rating,
    r.review_title
FROM accommodations a
LEFT JOIN reviews r
    ON a.accommodation_id = r.accommodation_id
WHERE r.review_id IS NULL
ORDER BY a.accommodation_id;
-- ============================================================
-- 15. LEFT JOIN - Alojamientos sin reservas
-- Filtrar NULL para encontrar alojamientos sin reservas.
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS alojamiento,
    b.booking_id,
    b.booking_reference
FROM accommodations a
LEFT JOIN bookings b
    ON a.accommodation_id = b.accommodation_id
WHERE b.booking_id IS NULL
ORDER BY a.accommodation_id;
-- ============================================================
-- 16. AGG - Total ingresos
-- Calcular ingresos totales con SUM.
-- ============================================================
SELECT
    p.payment_status,
    SUM(p.amount) AS total_ingresos
FROM payments p
WHERE p.payment_status = 'Completed'
GROUP BY p.payment_status;
-- ============================================================
-- 17. AGG - Promedio rating
-- Calcular promedio de calificación por alojamiento con AVG.
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS alojamiento,
    ROUND(AVG(r.rating)::numeric, 2) AS promedio_rating,
    COUNT(r.review_id) AS total_resenas
FROM accommodations a
INNER JOIN reviews r
    ON a.accommodation_id = r.accommodation_id
GROUP BY a.accommodation_id, a.name
ORDER BY promedio_rating DESC, total_resenas DESC;

-- ============================================================
-- 18. AGG - Top alojamientos
-- Top de alojamientos. 
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS alojamiento,
    COUNT(b.booking_id) AS total_reservas
FROM accommodations a
INNER JOIN bookings b
    ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
ORDER BY total_reservas DESC, a.accommodation_id
LIMIT 5;
-- ============================================================
-- 19. HAVING - Más de 3 reservas
-- Agrupar alojamientos y filtrar con HAVING.
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS alojamiento,
    COUNT(b.booking_id) AS total_reservas
FROM accommodations a
INNER JOIN bookings b
    ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
HAVING COUNT(b.booking_id) > 3
ORDER BY total_reservas DESC, a.accommodation_id;
-- ============================================================
-- 20. Subconsulta - Alojamiento más caro
-- Buscar el alojamiento con el mayor precio usando subconsulta.
-- ============================================================
SELECT
    accommodation_id,
    name AS alojamiento,
    base_price_per_night,
    currency_code
FROM accommodations
WHERE base_price_per_night = (
    SELECT MAX(base_price_per_night)
    FROM accommodations
)
ORDER BY accommodation_id;
