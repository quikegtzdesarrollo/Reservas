# Script para configurar Git y subir el proyecto a GitHub Pages
# Ejecutar este script después de instalar Git

Write-Host "=== Configuración de Git para GitHub Pages ===" -ForegroundColor Green

# Verificar si Git está instalado
try {
    $gitVersion = git --version
    Write-Host "Git encontrado: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Git no está instalado. Por favor instala Git desde https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

# Inicializar repositorio Git
Write-Host "Inicializando repositorio Git..." -ForegroundColor Yellow
git init

# Configurar usuario de Git (reemplaza con tus datos)
Write-Host "Configurando usuario de Git..." -ForegroundColor Yellow
Write-Host "Por favor ingresa tu nombre de usuario de GitHub:"
$username = Read-Host
Write-Host "Por favor ingresa tu email de GitHub:"
$email = Read-Host

git config user.name $username
git config user.email $email

# Agregar todos los archivos
Write-Host "Agregando archivos al repositorio..." -ForegroundColor Yellow
git add .

# Hacer el primer commit
Write-Host "Haciendo el primer commit..." -ForegroundColor Yellow
git commit -m "Primer commit: Sistema de menú del congreso"

Write-Host "=== Configuración completada ===" -ForegroundColor Green
Write-Host ""
Write-Host "Ahora necesitas:" -ForegroundColor Cyan
Write-Host "1. Crear un repositorio en GitHub.com" -ForegroundColor White
Write-Host "2. Ejecutar los siguientes comandos:" -ForegroundColor White
Write-Host "   git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git" -ForegroundColor Yellow
Write-Host "   git branch -M main" -ForegroundColor Yellow
Write-Host "   git push -u origin main" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. En GitHub, ve a Settings > Pages y activa GitHub Pages" -ForegroundColor White
Write-Host "4. Selecciona la rama 'main' como fuente" -ForegroundColor White 