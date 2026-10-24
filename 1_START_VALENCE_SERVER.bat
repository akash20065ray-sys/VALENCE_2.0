@echo off
title VALENCE Core Database Engine (Port 6379)
color 0A
cls
echo ============================================================
echo   VALENCE IN-MEMORY STATE ENGINE (Pure Rust v1.0)
echo   Target Port:   127.0.0.1:6379 (12 CPU-Pinned Shards)
echo   Architecture:  Thread-per-core, Lock-Free Arenas, O(1) Wheel
echo ============================================================
echo.
echo [*] Checking for previous instances on port 6379...
taskkill /F /IM valence-server.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul

cd /d "C:\VALENCE"

if exist "target\release\valence-server.exe" (
    echo [OK] Starting Valence Server across 12 hardware CPU shards...
    echo [OK] Listening on 127.0.0.1:6379
    echo.
    "target\release\valence-server.exe"
) else (
    echo [ERROR] valence-server.exe not found in C:\VALENCE\target\release!
)

echo.
echo ============================================================
echo Server stopped.
echo ============================================================
pause
