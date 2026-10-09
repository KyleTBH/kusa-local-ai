@echo off
cd /d "%~dp0"
title Kusa v0.10.8
if not exist .venv\Scripts\python.exe (
 echo Setup is needed for this folder. Starting setup now...
 py -3 -m venv .venv
 if errorlevel 1 goto error
 .venv\Scripts\python.exe -m pip install -r requirements.txt
 if errorlevel 1 goto error
)
.venv\Scripts\python.exe server.py --open
pause
exit /b
:error
echo Setup failed. Please send a screenshot of this window.
pause
