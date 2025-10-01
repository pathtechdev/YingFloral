#!/bin/bash

# Ying Floral Docker Quick Start Script
# Made with 🌸 by Hiểu Anh

set -e

echo "🌸 Ying Floral - Docker Deployment"
echo "=================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your configuration before continuing!"
    echo ""
    echo "Minimum required changes:"
    echo "1. Set strong passwords for POSTGRES_PASSWORD"
    echo "2. Set JWT_SECRET and COOKIE_SECRET (use: openssl rand -hex 32)"
    echo "3. Update domain URLs for production"
    echo ""
    read -p "Press Enter after you've updated .env file..."
fi

echo ""
echo "🚀 Starting Docker containers..."
echo ""

# Build and start containers
docker-compose up -d --build

echo ""
echo "⏳ Waiting for services to be healthy..."
sleep 10

# Wait for backend to be ready
echo "Checking backend health..."
max_attempts=30
attempt=0
while ! curl -sf http://localhost:9000/health > /dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
        echo "❌ Backend failed to start within 5 minutes"
        echo "Check logs with: docker-compose logs backend"
        exit 1
    fi
    echo "Waiting for backend... (attempt $attempt/$max_attempts)"
    sleep 10
done

echo "✅ Backend is healthy!"
echo ""

# Ask if user wants to seed data
read -p "Do you want to seed flower shop data? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🌱 Seeding flower shop data..."
    docker-compose exec backend npm run seed:flower
    echo "✅ Data seeded successfully!"
fi

echo ""
echo "=================================="
echo "🎉 Deployment Complete!"
echo "=================================="
echo ""
echo "Access your application:"
echo "  🌐 Frontend:  http://localhost:8000"
echo "  🔧 Backend:   http://localhost:9000"
echo "  👨‍💼 Admin:     http://localhost:9000/app"
echo "  🗄️  Database:  localhost:5432"
echo ""
echo "Useful commands:"
echo "  View logs:       docker-compose logs -f"
echo "  Stop services:   docker-compose down"
echo "  Restart:         docker-compose restart"
echo "  Status:          docker-compose ps"
echo ""
echo "Made with 🌸 by Hiểu Anh" 