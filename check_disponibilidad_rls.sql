-- Script para verificar y corregir las políticas RLS de la tabla disponibilidad
-- Ejecutar este script en el SQL Editor de Supabase

-- 1. Verificar si RLS está habilitado en la tabla disponibilidad
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'disponibilidad';

-- 2. Verificar las políticas existentes en la tabla disponibilidad
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename = 'disponibilidad';

-- 3. Si hay políticas que bloquean la actualización, eliminarlas
DROP POLICY IF EXISTS "Users can update disponibilidad" ON public.disponibilidad;
DROP POLICY IF EXISTS "Users can insert disponibilidad" ON public.disponibilidad;
DROP POLICY IF EXISTS "Users can delete disponibilidad" ON public.disponibilidad;

-- 4. Crear políticas permisivas para la tabla disponibilidad (solo lectura para usuarios autenticados)
CREATE POLICY "Users can view disponibilidad" ON public.disponibilidad
    FOR SELECT USING (true);

-- 5. Permitir actualización sin restricciones (para la aplicación)
CREATE POLICY "Allow update disponibilidad" ON public.disponibilidad
    FOR UPDATE USING (true);

-- 6. Verificar que la tabla tenga los datos correctos
SELECT * FROM public.disponibilidad;

-- 7. Verificar que la tabla tenga la estructura correcta
\d public.disponibilidad;

-- 8. Si es necesario, insertar datos iniciales
-- INSERT INTO public.disponibilidad (id, desayunos, comidas, cenas) 
-- VALUES (1, 20, 20, 20) 
-- ON CONFLICT (id) DO NOTHING; 