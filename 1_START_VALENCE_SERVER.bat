@echo off
title VALENCE In-Memory State Engine (Port 6379)
color 0A
cls

echo ============================================================
echo   VALENCE IN-MEMORY STATE ENGINE (Port 6379)
echo   12 CPU-Pinned Shards -- Lock-Free Arena -- O(1) Wheel
echo ============================================================
echo.

:: Free port 6379 and 3000
taskkill /F /IM valence-server.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul

if exist "C:\VALENCE" cd /d "C:\VALENCE"

:: Run local telemetry bridge silently in background (NO browser popups)
if exist "demo_swiggy\server.js" (
    start "Valence-Bridge" /b cmd /c "node demo_swiggy\server.js >nul 2>&1"
)

:: Run the real Valence Core Database Engine in the foreground
if exist "C:\VALENCE\target\release\valence-server.exe" (
    cd /d "C:\VALENCE"
    "C:\VALENCE\target\release\valence-server.exe"
) else if exist "%~dp0valence-server.exe" (
    cd /d "%~dp0"
    "%~dp0valence-server.exe"
) else (
    echo [ERROR] valence-server.exe not found!
)

pause
