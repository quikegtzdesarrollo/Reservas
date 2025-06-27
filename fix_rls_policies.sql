-- Script para corregir las políticas RLS en la tabla reservas
-- Ejecutar este script en el SQL Editor de Supabase

-- 1. Verificar que RLS esté habilitado
ALTER TABLE public.reservas ENABLE ROW LEVEL SECURITY;

-- 2. Eliminar políticas existentes que puedan estar causando conflictos
DROP POLICY IF EXISTS "Users can view their own reservations" ON public.reservas;
DROP POLICY IF EXISTS "Users can insert their own reservations" ON public.reservas;
DROP POLICY IF EXISTS "Users can update their own reservations" ON public.reservas;
DROP POLICY IF EXISTS "Users can delete their own reservations" ON public.reservas;

-- 3. Crear políticas más permisivas para desarrollo (puedes ajustarlas después)
-- Política para permitir que usuarios autenticados vean sus propias reservas
CREATE POLICY "Users can view their own reservations" ON public.reservas
    FOR SELECT USING (auth.uid() = user_id);

-- Política para permitir que usuarios autenticados inserten reservas
CREATE POLICY "Users can insert their own reservations" ON public.reservas
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Política para permitir que usuarios autenticados actualicen sus reservas
CREATE POLICY "Users can update their own reservations" ON public.reservas
    FOR UPDATE USING (auth.uid() = user_id);

-- Política para permitir que usuarios autenticados eliminen sus reservas
CREATE POLICY "Users can delete their own reservations" ON public.reservas
    FOR DELETE USING (auth.uid() = user_id);

-- 4. Verificar que la columna user_id existe
-- Si no existe, ejecutar:
-- ALTER TABLE public.reservas ADD COLUMN user_id UUID;

-- 5. Crear índice para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_reservas_user_id ON public.reservas(user_id);

-- 6. Verificar las políticas creadas
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename = 'reservas'; 