@echo off
title VALENCE STUDIO DASHBOARD
echo ========================================================
echo   VALENCE STUDIO -- REALTIME CONTROL PLANE (PORT 8080)
echo ========================================================
echo.
start http://localhost:8080
node "%~dp0valence_dashboard\server.js"
pause
