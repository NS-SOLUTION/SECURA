
@echo off
setlocal
title SECURA.APP.01 - Instalacao e Inicializacao

REM Ir automaticamente para a pasta deste ficheiro
set "ROOT=%~dp0"

cd /d "%ROOT%"

color 0B
echo.
echo ==========================================
echo       SECURA.APP.01
echo   INSTALACAO E INICIALIZACAO
echo ==========================================
echo.

REM Verificar Node.js
where node >nul 2>nul
if errorlevel 1 (
    echo ERRO: Node.js nao esta instalado.
    echo Instale a versao LTS do Node.js.
    pause
    exit /b 1
)

REM Verificar NPM
where npm >nul 2>nul
if errorlevel 1 (
    echo ERRO: NPM nao encontrado.
    pause
    exit /b 1
)

REM Verificar estrutura do projeto
if not exist "package.json" (
    echo ERRO: package.json do Frontend nao encontrado.
    pause
    exit /b 1
)

if not exist "backend\package.json" (
    echo ERRO: backend\package.json nao encontrado.
    pause
    exit /b 1
)

REM Criar ficheiro ENV caso nao exista
if not exist "backend\.env" (
    if exist "backend\.env.example" (
        copy "backend\.env.example" "backend\.env" >nul
        echo Ficheiro backend\.env criado.
    ) else (
        echo ERRO: backend\.env.example nao encontrado.
        pause
        exit /b 1
    )
)

echo.
echo [1/4] A instalar dependencias do FRONTEND...
echo.

call npm install
if errorlevel 1 goto erro

echo.
echo [2/4] A instalar dependencias do BACKEND...
echo.

pushd "%ROOT%backend"
call npm install
if errorlevel 1 (
    popd
    goto erro
)
popd

echo.
echo ==========================================
echo       INSTALACAO CONCLUIDA!
echo ==========================================
echo.

echo [3/4] A iniciar o BACKEND...
start "SECURA - BACKEND" cmd.exe /k "cd /d ""%ROOT%backend"" && npm run dev"

timeout /t 3 /nobreak >nul

echo [4/4] A iniciar o FRONTEND...
start "SECURA - FRONTEND" cmd.exe /k "cd /d ""%ROOT%"" && npm run dev"

echo.
echo ==========================================
echo       SECURA.APP.01 INICIADO
echo ==========================================
echo.
echo FRONTEND: http://localhost:5173
echo BACKEND:  http://localhost:4000
echo.
echo Mantenha as duas janelas abertas.
echo Para utilizar a base de dados, mantenha
echo o MySQL do XAMPP em funcionamento.
echo.
pause
exit /b 0

:erro
echo.
echo ==========================================
echo ERRO DURANTE A INSTALACAO!
echo Verifique a mensagem apresentada acima.
echo ==========================================
pause
exit /b 1
