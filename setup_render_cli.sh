#!/bin/sh
# Setup script for Render CLI in Minis/iSH environment

echo "Render CLI Setup for Minis/iSH"
echo "================================"

# Check if we're in Minis/iSH environment
if [ ! -d "/var/minis" ]; then
    echo "Warning: This script is designed for Minis/iSH environment"
    echo "You may need to adjust paths for your environment"
fi

echo ""
echo "1. Installing Python dependencies..."

# Check if requests is installed
if python3 -c "import requests" 2>/dev/null; then
    echo "✓ requests library is already installed"
else
    echo "Installing requests library..."
    if pip3 install requests; then
        echo "✓ requests library installed successfully"
    else
        echo "✗ Failed to install requests library"
        echo "Try: apk add py3-pip && pip3 install requests"
        exit 1
    fi
fi

echo ""
echo "2. Installing wrapper script..."

# Copy files to Minis workspace
echo "Copying files to /var/minis/workspace/..."
mkdir -p /var/minis/workspace
cp render_cli.py /var/minis/workspace/
cp render /var/minis/workspace/

# Install wrapper script to /usr/local/bin
echo "Installing render command to /usr/local/bin..."
cp render /usr/local/bin/
chmod +x /usr/local/bin/render

echo "✓ Wrapper script installed to /usr/local/bin/render"

echo ""
echo "3. Checking API key configuration..."

if [ -n "$RENDER_API_KEY" ]; then
    echo "✓ RENDER_API_KEY is already set"
    echo "Current key: ${RENDER_API_KEY:0:10}..."
else
    echo "✗ RENDER_API_KEY is not set"
    echo ""
    echo "To set your Render API key:"
    echo "1. Go to https://dashboard.render.com/account/api-keys"
    echo "2. Create a new API key or use an existing one"
    echo "3. Set it as an environment variable in Minis:"
    echo ""
    echo "   [Set RENDER_API_KEY](minis://settings/environments?create_key=RENDER_API_KEY&create_value=)"
    echo ""
    echo "Or set it temporarily:"
    echo "   export RENDER_API_KEY='your-api-key-here'"
    echo ""
fi

echo ""
echo "4. Testing installation..."

if command -v render >/dev/null 2>&1; then
    echo "✓ Render CLI is installed and ready to use"
    echo ""
    echo "Try these commands:"
    echo "  render help                    - Show help"
    echo "  render services list           - List your Render services"
    echo "  render version                 - Show version"
else
    echo "✗ Render CLI not found in PATH"
    echo "Try running: ./render [command] from this directory"
fi

echo ""
echo "Setup complete!"
echo ""
echo "Files installed:"
echo "  • /var/minis/workspace/render_cli.py - Main Python script"
echo "  • /var/minis/workspace/render        - Wrapper script (backup)"
echo "  • /usr/local/bin/render              - Command-line executable"
echo ""
echo "For help, run: render help"