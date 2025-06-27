-- Script para crear funciones administrativas para acceder a todas las reservas
-- Primero eliminamos las funciones existentes si las hay

-- Eliminar funciones existentes
DROP FUNCTION IF EXISTS obtener_todas_reservas_admin(DATE, TEXT);
DROP FUNCTION IF EXISTS obtener_resumen_reservas_admin(DATE);

-- Función para obtener todas las reservas sin restricciones de RLS
-- Esta función puede ser llamada desde el cliente anónimo

CREATE OR REPLACE FUNCTION obtener_todas_reservas_admin(
    p_fecha DATE DEFAULT NULL,
    p_tipo TEXT DEFAULT NULL
)
RETURNS TABLE (
    id UUID,
    nombre TEXT,
    celular TEXT,
    personas INTEGER,
    fecha DATE,
    tipo TEXT,
    user_id UUID,
    created_at TIMESTAMP
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Esta función se ejecuta con los privilegios del creador (bypass RLS)
    RETURN QUERY
    SELECT 
        r.id,
        r.nombre,
        r.celular,
        r.personas,
        r.fecha,
        r.tipo,
        r.user_id,
        r.created_at
    FROM reservas r
    WHERE (p_fecha IS NULL OR r.fecha = p_fecha)
      AND (p_tipo IS NULL OR r.tipo = p_tipo)
    ORDER BY r.nombre ASC;
END;
$$;

-- Dar permisos para ejecutar la función
GRANT EXECUTE ON FUNCTION obtener_todas_reservas_admin TO anon;
GRANT EXECUTE ON FUNCTION obtener_todas_reservas_admin TO authenticated;

-- Función para obtener resumen de reservas por fecha
CREATE OR REPLACE FUNCTION obtener_resumen_reservas_admin(p_fecha DATE)
RETURNS TABLE (
    tipo TEXT,
    total_personas BIGINT
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.tipo,
        SUM(r.personas) as total_personas
    FROM reservas r
    WHERE r.fecha = p_fecha
    GROUP BY r.tipo
    ORDER BY r.tipo;
END;
$$;

-- Dar permisos para ejecutar la función de resumen
GRANT EXECUTE ON FUNCTION obtener_resumen_reservas_admin TO anon;
GRANT EXECUTE ON FUNCTION obtener_resumen_reservas_admin TO authenticated; 