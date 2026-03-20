#!/bin/sh
# Setup script for Render CLI
# Installs the wrapper script and checks dependencies

set -e

echo "Render CLI Setup"
echo "================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

echo ""
echo "1. Checking dependencies..."

# Check Python 3
if command -v python3 >/dev/null 2>&1; then
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    print_status 0 "Python $PYTHON_VERSION is installed"
else
    print_status 1 "Python 3 is not installed"
    echo "   Install Python 3:"
    echo "   - Ubuntu/Debian: sudo apt install python3 python3-pip"
    echo "   - macOS: brew install python3"
    echo "   - Alpine: apk add python3 py3-pip"
    exit 1
fi

# Check pip3
if command -v pip3 >/dev/null 2>&1; then
    print_status 0 "pip3 is installed"
else
    print_status 1 "pip3 is not installed"
    echo "   Install pip3 with your package manager"
    exit 1
fi

echo ""
echo "2. Installing Python dependencies..."

# Install requests library
if python3 -c "import requests" 2>/dev/null; then
    print_status 0 "requests library is already installed"
else
    echo "Installing requests library..."
    if pip3 install requests --quiet; then
        print_status 0 "requests library installed successfully"
    else
        print_status 1 "Failed to install requests library"
        echo "   Try: sudo pip3 install requests"
        exit 1
    fi
fi

echo ""
echo "3. Setting up wrapper script..."

# Determine installation directory
if [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
    echo "Installing to $INSTALL_DIR (system-wide)"
elif [ -w "$HOME/.local/bin" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    echo "Installing to $INSTALL_DIR (user-local)"
    mkdir -p "$INSTALL_DIR"
else
    INSTALL_DIR="."
    echo "Installing to current directory (no write permission to system directories)"
fi

# Copy wrapper script
WRAPPER_SRC="render"
WRAPPER_DEST="$INSTALL_DIR/render"

if [ -f "$WRAPPER_SRC" ]; then
    cp "$WRAPPER_SRC" "$WRAPPER_DEST"
    chmod +x "$WRAPPER_DEST"
    print_status 0 "Wrapper script installed to $WRAPPER_DEST"
else
    # Create wrapper script if it doesn't exist
    cat > "$WRAPPER_DEST" << 'EOF'
#!/bin/sh
# Render CLI wrapper script

# Find the render_cli.py script
if [ -f "./render_cli.py" ]; then
    SCRIPT_PATH="./render_cli.py"
elif [ -f "$(dirname "$0")/render_cli.py" ]; then
    SCRIPT_PATH="$(dirname "$0")/render_cli.py"
elif [ -f "/usr/local/bin/render_cli.py" ]; then
    SCRIPT_PATH="/usr/local/bin/render_cli.py"
else
    echo "Error: render_cli.py not found"
    echo "Please ensure render_cli.py is in your PATH or current directory"
    exit 1
fi

# Run the Python script
exec python3 "$SCRIPT_PATH" "$@"
EOF
    chmod +x "$WRAPPER_DEST"
    print_status 0 "Wrapper script created at $WRAPPER_DEST"
fi

# Add to PATH if needed
if [ "$INSTALL_DIR" != "." ] && ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo ""
    echo "${YELLOW}Note: $INSTALL_DIR is not in your PATH${NC}"
    echo "Add it to your PATH by adding this to your shell profile:"
    echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
fi

echo ""
echo "4. Checking API key configuration..."

if [ -n "$RENDER_API_KEY" ]; then
    print_status 0 "RENDER_API_KEY is set"
    echo "   Current key: ${RENDER_API_KEY:0:10}..."
else
    print_status 1 "RENDER_API_KEY is not set"
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
    echo "For one-time use, you can run:"
    echo "   RENDER_API_KEY='your-key' render [command]"
fi

echo ""
echo "5. Testing installation..."

if command -v render >/dev/null 2>&1 || [ -f "./render" ]; then
    print_status 0 "Render CLI is ready to use"
else
    print_status 1 "Render CLI not found in PATH"
    echo "   Run from current directory: ./render [command]"
fi

echo ""
echo "${GREEN}Setup complete!${NC}"
echo ""
echo "Available commands:"
echo "  render help                    - Show help message"
echo "  render version                 - Show version information"
echo "  render services list           - List all Render services"
echo "  render services show <id>      - Show service details"
echo "  render deployments <id>        - List service deployments"
echo ""
echo "To test the CLI, run:"
echo "  render help"
echo ""
echo "For more information, see:"
echo "  https://github.com/gugu33/Render-CLI-py"