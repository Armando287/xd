@echo off
setlocal enabledelayedexpansion

REM Configura el repositorio de GitHub
set REPO_URL=https://github.com/Armando287/xd.git
set BRANCH=main

REM Directorio del script (donde está alojado el script)
set WORK_DIR=%~dp0

REM Cambia al directorio del script
cd /d "%WORK_DIR%"

REM Inicializa el repositorio si no existe
if not exist .git (
    echo Inicializando el repositorio Git...
    git init
    git remote add origin %REPO_URL%
    git fetch origin %BRANCH%
    git checkout -b %BRANCH%
)

REM Tamaño del lote
set batchSize=100
set /a counter=0

REM Procesar archivos no rastreados
echo Procesando archivos no rastreados...
for /f "delims=" %%f in ('git ls-files --others --exclude-standard') do (
    set "file=%%f"
    echo Agregando archivo no rastreado: "!file!"
    git add "!file!"
    
    if !ERRORLEVEL! neq 0 (
        echo Error al agregar archivo: "!file!" con error nivel: !ERRORLEVEL!
    )
    
    set /a counter+=1

    REM Cada 100 archivos, hace commit y push
    if !counter! geq %batchSize% (
        echo Haciendo commit y push de 100 archivos no rastreados...
        git commit -m "Subida automática de lote de archivos no rastreados"
        if !ERRORLEVEL! neq 0 (
            echo Error al hacer commit. Error nivel: !ERRORLEVEL!
            exit /b 1
        )
        git push origin %BRANCH%
        if !ERRORLEVEL! neq 0 (
            echo Error al hacer push. Intentando hacer pull para resolver conflictos...
            git pull origin %BRANCH%
            echo Intentando hacer push nuevamente...
            git push origin %BRANCH%
        )
        set /a counter=0
    )
)

REM Realiza commit y push para los archivos restantes (si quedan menos de 100)
if !counter! gtr 0 (
    echo Haciendo commit y push para los archivos no rastreados restantes...
    git commit -m "Subida automática de los archivos no rastreados restantes"
    if !ERRORLEVEL! neq 0 (
        echo Error al hacer commit. Error nivel: !ERRORLEVEL!
        exit /b 1
    )
    git push origin %BRANCH%
    if !ERRORLEVEL! neq 0 (
        echo Error al hacer push. Intentando hacer pull para resolver conflictos...
        git pull origin %BRANCH%
        echo Intentando hacer push nuevamente...
        git push origin %BRANCH%
    )
)

REM Procesar archivos rastreados que han cambiado
echo Procesando archivos rastreados modificados...
set /a counter=0
for /f "delims=" %%f in ('git diff --name-only --cached') do (
    set "file=%%f"
    echo Agregando archivo rastreado modificado: "!file!"
    git add "!file!"
    
    if !ERRORLEVEL! neq 0 (
        echo Error al agregar archivo: "!file!" con error nivel: !ERRORLEVEL!
    )
    
    set /a counter+=1

    REM Cada 100 archivos, hace commit y push
    if !counter! geq %batchSize% (
        echo Haciendo commit y push de 100 archivos rastreados modificados...
        git commit -m "Subida automática de lote de archivos rastreados modificados"
        if !ERRORLEVEL! neq 0 (
            echo Error al hacer commit. Error nivel: !ERRORLEVEL!
            exit /b 1
        )
        git push origin %BRANCH%
        if !ERRORLEVEL! neq 0 (
            echo Error al hacer push. Intentando hacer pull para resolver conflictos...
            git pull origin %BRANCH%
            echo Intentando hacer push nuevamente...
            git push origin %BRANCH%
        )
        set /a counter=0
    )
)

REM Realiza commit y push para los archivos restantes (si quedan menos de 100)
if !counter! gtr 0 (
    echo Haciendo commit y push para los archivos rastreados modificados restantes...
    git commit -m "Subida automática de los archivos rastreados modificados restantes"
    if !ERRORLEVEL! neq 0 (
        echo Error al hacer commit. Error nivel: !ERRORLEVEL!
        exit /b 1
    )
    git push origin %BRANCH%
    if !ERRORLEVEL! neq 0 (
        echo Error al hacer push. Intentando hacer pull para resolver conflictos...
        git pull origin %BRANCH%
        echo Intentando hacer push nuevamente...
        git push origin %BRANCH%
    )
)

echo Subida completada.
pause
