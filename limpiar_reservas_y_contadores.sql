-- Script para limpiar todas las reservas y reiniciar contadores
-- ⚠️ ADVERTENCIA: Este script eliminará TODAS las reservas existentes
-- Ejecutar este script en el SQL Editor de Supabase

-- 1. Verificar el estado actual antes de limpiar
SELECT 'ESTADO ACTUAL ANTES DE LIMPIAR:' as info;
SELECT 'Reservas existentes:' as tipo, COUNT(*) as cantidad FROM public.reservas;
SELECT 'Disponibilidad actual:' as tipo, desayunos, comidas, cenas FROM public.disponibilidad WHERE id = 1;

-- 2. Limpiar TODAS las reservas de la tabla reservas
DELETE FROM public.reservas;
SELECT 'Reservas eliminadas. Filas afectadas: ' || ROW_COUNT() as resultado;

-- 3. Reiniciar los contadores de disponibilidad a 20
UPDATE public.disponibilidad 
SET 
    desayunos = 20,
    comidas = 20,
    cenas = 20
WHERE id = 1;

SELECT 'Contadores reiniciados a 20. Filas afectadas: ' || ROW_COUNT() as resultado;

-- 4. Verificar el estado después de limpiar
SELECT 'ESTADO DESPUÉS DE LIMPIAR:' as info;
SELECT 'Reservas existentes:' as tipo, COUNT(*) as cantidad FROM public.reservas;
SELECT 'Disponibilidad actual:' as tipo, desayunos, comidas, cenas FROM public.disponibilidad WHERE id = 1;

-- 5. Verificar que la tabla disponibilidad tenga el registro correcto
SELECT 'Verificación final de disponibilidad:' as info;
SELECT * FROM public.disponibilidad WHERE id = 1; 