@echo off
title VALENCE Core Engine (6379) - Swiggy Web Server (3000)
color 0A
cls
echo ============================================================
echo   VALENCE IN-MEMORY STATE ENGINE (Pure Rust v1.0)
echo   Target Port:   127.0.0.1:6379 (12 CPU-Pinned Shards)
echo   Architecture:  Thread-per-core, Lock-Free Arenas, O(1) Wheel
echo   Web Interface: http://localhost:3000 (Pure Swiggy Food App)
echo ============================================================
echo.
echo [*] Checking and freeing ports 6379 and 3000...
taskkill /F /IM valence-server.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul

cd /d "C:\VALENCE"

echo [*] Starting Valence 12-Core Engine daemon on 127.0.0.1:6379...
start "Valence Engine Daemon" /b "target\release\valence-server.exe"
ping -n 3 127.0.0.1 >nul

echo [OK] Valence Database Engine active on port 6379.
echo [*] Launching Swiggy Food App in your default browser...
start http://localhost:3000

echo [*] Starting Swiggy Live Application Server on http://localhost:3000...
echo [*] Live database queries and mutations will stream below in real time:
echo ============================================================
echo.
node demo_swiggy\server.js
pause
