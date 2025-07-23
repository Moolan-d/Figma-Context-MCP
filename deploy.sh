#!/bin/bash

# Figma MCP Docker Deployment Script

set -e  # Exit on any error

echo "Figma MCP Docker Deployment Script"
echo "==================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose is not installed. Please install docker-compose first."
    exit 1
fi

# Check if .env file exists, if not create one
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cat > .env << EOF
# Figma MCP Server Configuration

# You must provide either FIGMA_API_KEY or FIGMA_OAUTH_TOKEN
FIGMA_API_KEY=
# FIGMA_OAUTH_TOKEN=

# Server configuration
PORT=3333
OUTPUT_FORMAT=yaml
SKIP_IMAGE_DOWNLOADS=false
EOF
    echo "Please edit the .env file and add your FIGMA_API_KEY or FIGMA_OAUTH_TOKEN"
    echo "Then run this script again."
    exit 1
fi

# Check if required environment variables are set
if [ -z "$FIGMA_API_KEY" ] && [ -z "$FIGMA_OAUTH_TOKEN" ] && ! grep -q "FIGMA_API_KEY=" .env && ! grep -q "FIGMA_OAUTH_TOKEN=" .env; then
    echo "Error: FIGMA_API_KEY or FIGMA_OAUTH_TOKEN must be set in .env file or as environment variables"
    echo "Please edit the .env file and add your FIGMA_API_KEY or FIGMA_OAUTH_TOKEN"
    exit 1
fi

echo "Building Docker image..."
docker-compose build

echo "Starting Figma MCP Server..."
docker-compose up -d

echo ""
echo "Deployment completed successfully!"
echo "The Figma MCP Server is now running in the background."
echo ""
echo "To check the logs, run: docker-compose logs -f"
echo "To stop the server, run: docker-compose down"
echo ""
echo "The server is accessible at: http://localhost:3333"