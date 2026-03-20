# Render CLI (Python)

A Python-based command-line interface for managing Render services via the Render API.

## Features

- List all Render services
- View detailed service information
- Check service deployments
- Lightweight and dependency-free (only `requests` library)
- Works on any system with Python 3

## Installation

### Option 1: Quick Install (Linux/macOS)

```bash
# Clone the repository
git clone https://github.com/gugu33/Render-CLI-py.git
cd Render-CLI-py

# Make the wrapper script executable
chmod +x render

# Install Python dependencies
pip3 install requests

# Add to PATH (optional)
sudo cp render /usr/local/bin/
```

### Option 2: Manual Setup

```bash
# Download the Python script
curl -O https://raw.githubusercontent.com/gugu33/Render-CLI-py/main/render_cli.py

# Download the wrapper script
curl -O https://raw.githubusercontent.com/gugu33/Render-CLI-py/main/render
chmod +x render

# Install Python dependencies
pip3 install requests
```

### Option 3: Using as Python Module

```bash
# Just download the Python script
curl -O https://raw.githubusercontent.com/gugu33/Render-CLI-py/main/render_cli.py

# Run directly
python3 render_cli.py services list
```

## Configuration

### 1. Get Render API Key
1. Go to [Render Dashboard → Account → API Keys](https://dashboard.render.com/account/api-keys)
2. Create a new API key or use an existing one

### 2. Set Environment Variable

**Linux/macOS:**
```bash
export RENDER_API_KEY="your-api-key-here"
```

**Windows (Command Prompt):**
```cmd
set RENDER_API_KEY=your-api-key-here
```

**Windows (PowerShell):**
```powershell
$env:RENDER_API_KEY="your-api-key-here"
```

**Permanent setup (add to shell profile):**
```bash
echo 'export RENDER_API_KEY="your-api-key-here"' >> ~/.bashrc
# or ~/.zshrc, ~/.profile, etc.
source ~/.bashrc
```

## Usage

### Basic Commands
```bash
render help                    # Show help message
render version                 # Show version information
```

### Service Management
```bash
render services list           # List all Render services
render services show <id>      # Show detailed service information
render deployments <id>        # List deployments for a service
```

### Examples

1. **List all services:**
   ```bash
   render services list
   ```

2. **Show details for a specific service:**
   ```bash
   render services show srv-cmgrmrta73kc73dsoo80
   ```

3. **List deployments for a service:**
   ```bash
   render deployments srv-cmgrmrta73kc73dsoo80
   ```

## Files in This Repository

- `render_cli.py` - Main Python script for Render API interaction
- `render` - Wrapper script for easy command-line usage
- `setup_render_cli.sh` - Setup script for Minis/iSH environment
- `README.md` - This documentation file

## Dependencies

- Python 3.6+
- `requests` library (install with `pip3 install requests`)

## API Reference

The CLI uses the official [Render API](https://api.render.com/v1):
- Base URL: `https://api.render.com/v1`
- Authentication: Bearer token (`RENDER_API_KEY`)
- Endpoints: `/services`, `/services/{id}`, `/services/{id}/deploys`

## Troubleshooting

### Common Issues

1. **"RENDER_API_KEY is not set"**
   ```bash
   # Check if variable is set
   echo $RENDER_API_KEY
   
   # Set it if not
   export RENDER_API_KEY="your-key"
   ```

2. **"python3: command not found"**
   ```bash
   # Install Python 3
   # Ubuntu/Debian:
   sudo apt install python3 python3-pip
   
   # macOS:
   brew install python3
   
   # Alpine Linux:
   apk add python3 py3-pip
   ```

3. **"ModuleNotFoundError: No module named 'requests'"**
   ```bash
   pip3 install requests
   ```

4. **"Permission denied" when running `render`**
   ```bash
   chmod +x render
   ```

### Testing API Connectivity
```bash
# Test if API key works
curl -s -H "Authorization: Bearer $RENDER_API_KEY" \
  "https://api.render.com/v1/services" | head -c 100
```

## Development

### Adding New Features
1. Fork the repository
2. Modify `render_cli.py` to add new functionality
3. Test your changes
4. Submit a pull request

### Running Tests
```bash
# Basic functionality test
python3 render_cli.py help

# Test with mock API key (will fail but show error handling)
RENDER_API_KEY="test" python3 render_cli.py services list
```

## License

This project is open source and available for personal and commercial use.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request