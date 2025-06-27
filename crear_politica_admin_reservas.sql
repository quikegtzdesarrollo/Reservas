-- Script para crear políticas administrativas para la tabla reservas
-- Este script permite que un rol de servicio acceda a todas las reservas sin restricciones de RLS

-- 1. Crear un rol de servicio si no existe
-- CREATE ROLE service_role_admin;

-- 2. Habilitar RLS en la tabla reservas (si no está habilitado)
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;

-- 3. Crear política para permitir acceso completo al rol de servicio
CREATE POLICY "Permitir acceso administrativo completo" ON reservas
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- 4. Crear política específica para lectura administrativa
CREATE POLICY "Permitir lectura administrativa de reservas" ON reservas
    FOR SELECT
    TO service_role
    USING (true);

-- 5. Verificar las políticas existentes
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'reservas';

-- 6. Verificar que el rol service_role tiene los permisos correctos
SELECT 
    grantee,
    table_name,
    privilege_type
FROM information_schema.role_table_grants 
WHERE table_name = 'reservas' 
AND grantee = 'service_role'; 