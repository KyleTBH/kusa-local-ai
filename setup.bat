@echo off
cd /d "%~dp0"
py -3 -m venv .venv
if errorlevel 1 goto error
.venv\Scripts\python.exe -m pip install -r requirements.txt
if errorlevel 1 goto error
echo Setup complete. Double-click start.bat to open Kusa.
pause
exit /b 0
:error
echo Setup failed. Install Python 3.10 or later from python.org, with the Python launcher, then try again.
pause
exit /b 1
