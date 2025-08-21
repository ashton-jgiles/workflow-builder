@echo off
setlocal enabledelayedexpansion

echo 🚀 Starting Cloud Cost Dashboard...

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker Desktop and try again.
    pause
    exit /b 1
)

REM Check if docker-compose is available
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ❌ docker-compose is not installed. Please install Docker Compose and try again.
    pause
    exit /b 1
)

echo 📦 Building and starting services...

REM Start the services
docker-compose up -d --build

echo ⏳ Waiting for services to be ready...

REM Wait for database to be healthy
echo 🔍 Checking database health...
:wait_db
docker-compose exec -T postgres pg_isready -U cloud_cost_user -d cloud_cost_db >nul 2>&1
if errorlevel 1 (
    echo ⏳ Waiting for database...
    timeout /t 2 /nobreak >nul
    goto wait_db
)

REM Wait for backend to be ready
echo 🔍 Checking backend health...
:wait_backend
curl -f http://localhost:3001/health >nul 2>&1
if errorlevel 1 (
    echo ⏳ Waiting for backend...
    timeout /t 2 /nobreak >nul
    goto wait_backend
)

REM Wait for frontend to be ready
echo 🔍 Checking frontend health...
:wait_frontend
curl -f http://localhost:8080 >nul 2>&1
if errorlevel 1 (
    echo ⏳ Waiting for frontend...
    timeout /t 2 /nobreak >nul
    goto wait_frontend
)

echo.
echo ✅ All services are running!
echo.
echo 🌐 Access your application:
echo    Frontend: http://localhost:8080
echo    Backend API: http://localhost:3001
echo    Database: localhost:5432
echo.
echo 📊 Test the API:
echo    curl http://localhost:3001/users
echo.
echo 🛑 To stop the services:
echo    docker-compose down
echo.
pause
