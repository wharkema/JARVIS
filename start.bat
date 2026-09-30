@echo off
REM start.bat - Start JARVIS backend en frontend
REM Plaats dit bestand in de root van de JARVIS-repo (naast de mappen backend/ en frontend/)

setlocal

echo ============================================
echo   JARVIS starten
echo ============================================

REM --- Backend virtual environment aanmaken indien nodig ---
if not exist "backend\.venv\Scripts\activate.bat" (
    echo [Backend] Virtual environment niet gevonden, wordt aangemaakt...
    pushd backend
    python -m venv .venv
    call .venv\Scripts\activate.bat
    pip install -e .
    popd
) else (
    echo [Backend] Virtual environment gevonden.
)

REM --- Frontend dependencies installeren indien nodig ---
if not exist "frontend\node_modules" (
    echo [Frontend] node_modules niet gevonden, npm install wordt uitgevoerd...
    pushd frontend
    call npm install
    popd
) else (
    echo [Frontend] node_modules gevonden.
)

REM --- Backend starten in nieuw venster ---
echo [Backend] Starten op http://localhost:8000 ...
start "JARVIS Backend" cmd /k "cd /d %~dp0backend && call .venv\Scripts\activate.bat && uvicorn main:app --reload --port 8000"

REM --- Even wachten zodat backend kan opstarten ---
timeout /t 3 /nobreak >nul

REM --- Frontend starten in nieuw venster ---
echo [Frontend] Starten op http://localhost:3000 ...
start "JARVIS Frontend" cmd /k "cd /d %~dp0frontend && npm run dev"

echo.
echo ============================================
echo   Backend  : http://localhost:8000
echo   Frontend : http://localhost:3000
echo   (Sluit de geopende vensters om te stoppen)
echo ============================================

endlocal
