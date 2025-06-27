-- Script completo para limpiar todo el sistema
-- ⚠️ ADVERTENCIA: Este script eliminará TODOS los datos de reservas y usuarios
-- Ejecutar este script en el SQL Editor de Supabase

-- Configuración de contadores
DO $$
DECLARE
    valor_desayunos INTEGER := 20;  -- Cambiar aquí el valor deseado
    valor_comidas INTEGER := 20;    -- Cambiar aquí el valor deseado
    valor_cenas INTEGER := 20;      -- Cambiar aquí el valor deseado
    reservas_eliminadas INTEGER;
    usuarios_eliminados INTEGER;
    contadores_actualizados INTEGER;
BEGIN
    -- 1. Mostrar configuración
    RAISE NOTICE '=== CONFIGURACIÓN ===';
    RAISE NOTICE 'Valores de contadores: Desayunos=%, Comidas=%, Cenas=%', valor_desayunos, valor_comidas, valor_cenas;
    
    -- 2. Verificar estado actual
    RAISE NOTICE '=== ESTADO ACTUAL ===';
    RAISE NOTICE 'Reservas existentes: %', (SELECT COUNT(*) FROM public.reservas);
    RAISE NOTICE 'Usuarios registrados: %', (SELECT COUNT(*) FROM public.usuarios);
    RAISE NOTICE 'Disponibilidad actual: %', (SELECT CONCAT('D:', desayunos, ' C:', comidas, ' Ce:', cenas) FROM public.disponibilidad WHERE id = 1);
    
    -- 3. Eliminar todas las reservas
    DELETE FROM public.reservas;
    GET DIAGNOSTICS reservas_eliminadas = ROW_COUNT;
    RAISE NOTICE 'Reservas eliminadas: %', reservas_eliminadas;
    
    -- 4. Eliminar todos los usuarios (opcional - descomentar si es necesario)
    -- DELETE FROM public.usuarios;
    -- GET DIAGNOSTICS usuarios_eliminados = ROW_COUNT;
    -- RAISE NOTICE 'Usuarios eliminados: %', usuarios_eliminados;
    
    -- 5. Reiniciar contadores
    UPDATE public.disponibilidad 
    SET 
        desayunos = valor_desayunos,
        comidas = valor_comidas,
        cenas = valor_cenas
    WHERE id = 1;
    GET DIAGNOSTICS contadores_actualizados = ROW_COUNT;
    RAISE NOTICE 'Contadores actualizados: %', contadores_actualizados;
    
    -- 6. Verificar estado final
    RAISE NOTICE '=== ESTADO FINAL ===';
    RAISE NOTICE 'Reservas existentes: %', (SELECT COUNT(*) FROM public.reservas);
    RAISE NOTICE 'Usuarios registrados: %', (SELECT COUNT(*) FROM public.usuarios);
    RAISE NOTICE 'Disponibilidad final: %', (SELECT CONCAT('D:', desayunos, ' C:', comidas, ' Ce:', cenas) FROM public.disponibilidad WHERE id = 1);
    
    RAISE NOTICE '✅ Limpieza completa finalizada exitosamente';
END $$; 