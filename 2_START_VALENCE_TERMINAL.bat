@echo off
title VALENCE Interactive Terminal - Dual-Engine CLI
color 0E
cls
if exist "%~dp0valence_terminal.py" (
    cd /d "%~dp0"
) else (
    cd /d "C:\VALENCE"
)
echo [*] Launching Valence Terminal CLI (127.0.0.1:6379)...
python valence_terminal.py
pause
