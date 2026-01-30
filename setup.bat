@echo off
REM ============ BACKEND PRESENSI - SETUP SCRIPT (WINDOWS) ============

echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║   Backend Presensi - Setup Script (Windows)            ║
echo ╚════════════════════════════════════════════════════════╝
echo.

REM Check if .env exists
if exist .env (
    echo ✅ .env file already exists
) else (
    echo 📝 Creating .env file from .env.example...
    copy .env.example .env
    echo ✅ .env created
    echo ⚠️  Please edit .env with your database and email credentials
)

echo.
echo 📦 Installing dependencies...
call npm install

echo.
echo ✅ Setup complete!
echo.
echo Next steps:
echo   1. Edit .env with your database and email credentials
echo   2. Create PostgreSQL database: createdb presensi
echo   3. Run database setup: psql presensi -f database.sql
echo   4. Start server: npm start (production) or npm run dev (development)
echo.
echo 🚀 Ready to go!
echo.
pause
