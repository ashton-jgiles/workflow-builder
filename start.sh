#!/bin/bash

# Cloud Cost Dashboard - Startup Script
# This script starts the entire application stack

set -e

echo "🚀 Starting Cloud Cost Dashboard..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

echo "📦 Building and starting services..."

# Start the services
docker-compose up -d --build

echo "⏳ Waiting for services to be ready..."

# Wait for database to be healthy
echo "🔍 Checking database health..."
until docker-compose exec -T postgres pg_isready -U cloud_cost_user -d cloud_cost_db > /dev/null 2>&1; do
    echo "⏳ Waiting for database..."
    sleep 2
done

# Wait for backend to be ready
echo "🔍 Checking backend health..."
until curl -f http://localhost:3001/health > /dev/null 2>&1; do
    echo "⏳ Waiting for backend..."
    sleep 2
done

# Wait for frontend to be ready
echo "🔍 Checking frontend health..."
until curl -f http://localhost:8080 > /dev/null 2>&1; do
    echo "⏳ Waiting for frontend..."
    sleep 2
done

echo ""
echo "✅ All services are running!"
echo ""
echo "🌐 Access your application:"
echo "   Frontend: http://localhost:8080"
echo "   Backend API: http://localhost:3001"
echo "   Database: localhost:5432"
echo ""
echo "📊 Test the API:"
echo "   curl http://localhost:3001/users"
echo ""
echo "🛑 To stop the services:"
echo "   docker-compose down"
echo ""
