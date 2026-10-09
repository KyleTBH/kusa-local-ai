@echo off
cd /d "%~dp0"
title Build Kusa for Windows

echo This builds Kusa.exe in the dist folder.
echo Python 3.10 or newer and an internet connection are needed for this one-time build.
echo Ollama and its AI model are installed separately and are not included in Kusa.exe.
echo.

py -3 --version
if errorlevel 1 goto python_error

py -3 -m pip install -r requirements.txt pyinstaller
if errorlevel 1 goto install_error

py -3 -m PyInstaller --noconfirm --clean --onefile --name Kusa --collect-all pypdf --add-data "web;web" server.py
if errorlevel 1 goto build_error

echo.
echo Build complete: dist\Kusa.exe
echo Double-click Kusa.exe. It opens Kusa in your browser and keeps a console window open.
echo Keep Ollama running to use Ask Kusa. After Ollama and the model are installed, AI can work offline.
pause
exit /b 0

:python_error
echo Python 3 was not found. Install Python 3.10 or newer, then try again.
pause
exit /b 1

:install_error
echo Could not install the build tools. Check your internet connection and try again.
pause
exit /b 1

:build_error
echo The build failed. Take a screenshot of this window and send it for help.
pause
exit /b 1
