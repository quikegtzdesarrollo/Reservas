-- Script para agregar campo entregado a la tabla reservas
-- Este campo permitirá marcar las reservas como entregadas

-- 1. Eliminar funciones existentes primero
DROP FUNCTION IF EXISTS obtener_todas_reservas_admin(DATE, TEXT);
DROP FUNCTION IF EXISTS actualizar_estado_entrega(UUID, BOOLEAN);

-- 2. Agregar el campo entregado a la tabla reservas
ALTER TABLE reservas 
ADD COLUMN entregado BOOLEAN DEFAULT FALSE;

-- 3. Crear un índice para mejorar el rendimiento de consultas por estado de entrega
CREATE INDEX idx_reservas_entregado ON reservas(entregado);

-- 4. Actualizar la función administrativa para incluir el nuevo campo
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
    entregado BOOLEAN
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
        r.entregado
    FROM reservas r
    WHERE (p_fecha IS NULL OR r.fecha = p_fecha)
      AND (p_tipo IS NULL OR r.tipo = p_tipo)
    ORDER BY r.nombre ASC;
END;
$$;

-- 5. Crear función para actualizar el estado de entrega
CREATE OR REPLACE FUNCTION actualizar_estado_entrega(
    p_id UUID,
    p_entregado BOOLEAN
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE reservas 
    SET entregado = p_entregado
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$;

-- 6. Dar permisos para ejecutar las funciones
GRANT EXECUTE ON FUNCTION obtener_todas_reservas_admin TO anon;
GRANT EXECUTE ON FUNCTION obtener_todas_reservas_admin TO authenticated;
GRANT EXECUTE ON FUNCTION actualizar_estado_entrega TO anon;
GRANT EXECUTE ON FUNCTION actualizar_estado_entrega TO authenticated;

-- 7. Verificar que el campo se agregó correctamente
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'reservas' 
AND column_name = 'entregado'; 