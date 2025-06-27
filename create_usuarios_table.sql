-- Script para crear la tabla usuarios
-- Ejecutar este script en el SQL Editor de Supabase

-- 1. Crear tabla usuarios si no existe
CREATE TABLE IF NOT EXISTS public.usuarios (
  id UUID PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  nombre TEXT NOT NULL,
  avatar_url TEXT NULL,
  ultimo_acceso TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

-- 2. Habilitar RLS
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;

-- 3. Eliminar políticas existentes
DROP POLICY IF EXISTS "Users can view their own user data" ON public.usuarios;
DROP POLICY IF EXISTS "Users can manage their own user data" ON public.usuarios;

-- 4. Crear políticas RLS
CREATE POLICY "Users can view their own user data" ON public.usuarios
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can manage their own user data" ON public.usuarios
    FOR ALL USING (auth.uid() = id);

-- 5. Crear índices
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON public.usuarios(email);
CREATE INDEX IF NOT EXISTS idx_usuarios_ultimo_acceso ON public.usuarios(ultimo_acceso);

-- 6. Crear función para actualizar timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 7. Crear trigger para updated_at
DROP TRIGGER IF EXISTS update_usuarios_updated_at ON public.usuarios;
CREATE TRIGGER update_usuarios_updated_at 
    BEFORE UPDATE ON public.usuarios 
    FOR EACH ROW 
    EXECUTE FUNCTION public.update_updated_at_column(); 