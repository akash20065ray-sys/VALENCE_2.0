@echo off
title VALENCE Cloud Tunnel & Live Mobile Endpoint (Port 3000)
color 0B
cls
echo ============================================================
echo   VALENCE 1-CLICK CLOUD TUNNEL & LIVE MOBILE QR CODE
echo   Connecting: http://localhost:3000 to Global HTTPS Edge
echo ============================================================
echo.
cd /d "%~dp0"
python valence_tunnel.py
pause
