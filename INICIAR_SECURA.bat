
@echo off
cd /d "%~dp0"

echo ==========================================
echo       INSTALACAO DO SECURA.APP.01
echo ==========================================

if not exist "package.json" (
 echo ERRO: package.json principal nao encontrado.
 pause
 exit /b 1
)

if not exist "backend\package.json" (
 echo ERRO: backend\package.json nao encontrado.
 pause
 exit /b 1
)

if not exist "backend\.env" (
 if exist "backend\.env.example" (
  copy "backend\.env.example" "backend\.env"
 )
)

echo.
echo [1/2] Instalando Frontend...
call npm install
if errorlevel 1 goto erro

echo.
echo [2/2] Instalando Backend...
cd /d "%~dp0backend"
call npm install
if errorlevel 1 goto erro

echo.
echo ==========================================
echo INSTALACAO CONCLUIDA COM SUCESSO!
echo ==========================================
echo.
echo Frontend: React + Vite
echo Backend: Node.js + Express
echo Banco: MySQL XAMPP
echo.
pause
exit /b 0

:erro
echo.
echo ERRO NA INSTALACAO!
pause
exit /b 1
