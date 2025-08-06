#!/bin/bash

# deploy.sh - Deployment script for Albion Online Build Generator
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="albion-build-generator"
PORT=${PORT:-8080}
DOMAIN=${DOMAIN:-localhost}

echo -e "${BLUE}🚀 Deploying Albion Online Build Generator${NC}"
echo "Project: $PROJECT_NAME"
echo "Port: $PORT"
echo "Domain: $DOMAIN"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

# Create project directory if it doesn't exist
if [ ! -d "$PROJECT_NAME" ]; then
    echo -e "${YELLOW}📁 Creating project directory...${NC}"
    mkdir -p "$PROJECT_NAME"
fi

cd "$PROJECT_NAME"

# Check if required files exist
required_files=("Dockerfile" "docker-compose.yml" "nginx.conf" "index.html")
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Missing required file: $file${NC}"
        echo "Please ensure all files are in the project directory."
        exit 1
    fi
done

echo -e "${YELLOW}🔍 Checking for existing containers...${NC}"
if docker ps -a --format "table {{.Names}}" | grep -q "$PROJECT_NAME"; then
    echo -e "${YELLOW}⚠️  Existing container found. Stopping and removing...${NC}"
    docker compose down
fi

echo -e "${YELLOW}🏗️  Building Docker image...${NC}"
docker compose build --no-cache

echo -e "${YELLOW}🚀 Starting container...${NC}"
docker compose up -d

# Wait for container to be ready
echo -e "${YELLOW}⏳ Waiting for container to be ready...${NC}"
sleep 5

# Health check
echo -e "${YELLOW}🏥 Performing health check...${NC}"
if curl -f -s "http://localhost:$PORT/health" > /dev/null; then
    echo -e "${GREEN}✅ Health check passed!${NC}"
else
    echo -e "${RED}❌ Health check failed. Checking logs...${NC}"
    docker compose logs
    exit 1
fi

# Display container status
echo -e "${YELLOW}📊 Container status:${NC}"
docker compose ps

# Display resource usage
echo -e "${YELLOW}💾 Resource usage:${NC}"
docker stats "$PROJECT_NAME" --no-stream

echo ""
echo -e "${GREEN}🎉 Deployment successful!${NC}"
echo -e "${GREEN}📱 Application is running at: http://localhost:$PORT${NC}"
echo ""
echo -e "${BLUE}Management commands:${NC}"
echo "  • Stop:    docker compose down"
echo "  • Restart: docker compose restart"
echo "  • Logs:    docker compose logs -f"
echo "  • Update:  ./update.sh"
echo ""
echo -e "${YELLOW}💡 Tips:${NC}"
echo "  • Access health check: curl http://localhost:$PORT/health"
echo "  • View logs: docker logs $PROJECT_NAME"
echo "  • Monitor resources: docker stats $PROJECT_NAME"