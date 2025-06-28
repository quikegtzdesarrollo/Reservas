-- Script para actualizar la función administrativa e incluir el campo preferencia
-- Este script actualiza la función obtener_todas_reservas_admin para incluir preferencias

-- 1. Eliminar función existente
DROP FUNCTION IF EXISTS obtener_todas_reservas_admin(DATE, TEXT);

-- 2. Actualizar la función administrativa para incluir el campo preferencia
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
    created_at TIMESTAMP,
    entregado BOOLEAN,
    preferencia TEXT
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
        r.created_at,
        r.entregado,
        r.preferencia
    FROM reservas r
    WHERE (p_fecha IS NULL OR r.fecha = p_fecha)
      AND (p_tipo IS NULL OR r.tipo = p_tipo)
    ORDER BY r.nombre ASC;
END;
$$;

-- 3. Dar permisos para ejecutar la función actualizada
GRANT EXECUTE ON FUNCTION obtener_todas_reservas_admin TO anon;
GRANT EXECUTE ON FUNCTION obtener_todas_reservas_admin TO authenticated;

-- 4. Verificar que la función se actualizó correctamente
SELECT 
    p.proname as function_name,
    pg_get_function_arguments(p.oid) as arguments,
    pg_get_function_result(p.oid) as return_type
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname = 'obtener_todas_reservas_admin'
AND n.nspname = 'public'; 