@echo off
title SWIGGY & BOOKMYSHOW WEB APPS (Port 3000)
color 0E
cls
echo ============================================================
echo   SWIGGY FOOD DELIVERY & BOOKMYSHOW APPS (Valence Engine)
echo   Swiggy Food App: http://localhost:3000
echo   BookMyShow App:  http://localhost:3000/cinema.html
echo   Valence Target:  127.0.0.1:6379 (Port 6379)
echo ============================================================
echo.
echo [*] Checking and releasing port 3000...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000 ^| findstr LISTENING') do (
    taskkill /f /pid %%a >nul 2>&1
)

echo [*] Opening Swiggy Food App in browser...
start http://localhost:3000

echo [*] Starting Node.js backend & Valence bridge...
cd /d "c:\project_placement"
node server.js
pause
