#!/bin/sh
# Setup script for Render CLI

echo "Render CLI Setup"
echo "================"

# Check if API key is already set
if [ -n "$RENDER_API_KEY" ]; then
    echo "✓ RENDER_API_KEY is already set"
    echo "Current key: ${RENDER_API_KEY:0:10}..."
else
    echo "✗ RENDER_API_KEY is not set"
    echo ""
    echo "To set your Render API key:"
    echo "1. Go to https://dashboard.render.com/account/api-keys"
    echo "2. Create a new API key or use an existing one"
    echo "3. Set it as an environment variable:"
    echo ""
    echo "   export RENDER_API_KEY='your-api-key-here'"
    echo ""
    echo "Or add it to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
    echo "   echo \"export RENDER_API_KEY='your-key'\" >> ~/.bashrc"
    echo ""
fi

echo ""
echo "Available commands:"
echo "  render help          - Show help"
echo "  render services list - List all services"
echo "  render version       - Show version"

echo ""
echo "To test the CLI, run:"
echo "  render services list"