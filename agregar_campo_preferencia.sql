-- Script para agregar campo preferencia a la tabla reservas
-- Este campo permitirá almacenar las preferencias de comida del usuario

-- 1. Eliminar funciones existentes primero
DROP FUNCTION IF EXISTS obtener_todas_reservas_admin(DATE, TEXT);
DROP FUNCTION IF EXISTS actualizar_preferencia(UUID, TEXT);

-- 2. Agregar el campo preferencia a la tabla reservas
ALTER TABLE reservas 
ADD COLUMN preferencia TEXT;

-- 3. Crear un índice para mejorar el rendimiento de consultas por preferencia
CREATE INDEX idx_reservas_preferencia ON reservas(preferencia);

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

-- 5. Crear función para actualizar la preferencia
CREATE OR REPLACE FUNCTION actualizar_preferencia(
    p_id UUID,
    p_preferencia TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE reservas 
    SET preferencia = p_preferencia
    WHERE id = p_id;
    
    RETURN FOUND;
END;
$$;

-- 6. Dar permisos para ejecutar las funciones
GRANT EXECUTE ON FUNCTION obtener_todas_reservas_admin TO anon;
GRANT EXECUTE ON FUNCTION obtener_todas_reservas_admin TO authenticated;
GRANT EXECUTE ON FUNCTION actualizar_preferencia TO anon;
GRANT EXECUTE ON FUNCTION actualizar_preferencia TO authenticated;

-- 7. Verificar que el campo se agregó correctamente
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'reservas' 
AND column_name = 'preferencia'; 