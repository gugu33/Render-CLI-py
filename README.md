# Render CLI for Minis/iSH

A Python-based Render CLI that works in the Minis/iSH environment (Alpine Linux on iOS).

## Installation

After cloning the repository, run the setup script to complete installation:

```bash
# Clone the repository
git clone https://github.com/gugu33/Render-CLI-py.git
cd Render-CLI-py

# Run the setup script
sh setup_render_cli.sh
```

The setup script will:
1. Check and install Python dependencies
2. Install the wrapper script to `/usr/local/bin/render`
3. Guide you through API key setup

## Setup

Your `RENDER_API_KEY` environment variable needs to be set. You can verify this by running:

```bash
echo $RENDER_API_KEY | head -c 10
```

If not set, the setup script will guide you through the process.

## Available Commands

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

## Examples

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

## Notes

- The CLI uses the official Render API (https://api.render.com/v1)
- All API calls require the `RENDER_API_KEY` environment variable
- The CLI is designed specifically for the Minis/iSH environment (Alpine Linux on iOS)
- The wrapper script (`render`) is installed to `/usr/local/bin/` for easy access
- For more advanced operations, you can modify the Python script directly

## Troubleshooting

If you encounter issues:

1. **Check API key:**
   ```bash
   echo $RENDER_API_KEY | wc -c
   ```

2. **Test API connectivity:**
   ```bash
   curl -s -H "Authorization: Bearer $RENDER_API_KEY" "https://api.render.com/v1/services" | head -c 100
   ```

3. **Re-run setup script:**
   ```bash
   sh setup_render_cli.sh
   ```

4. **Check wrapper script installation:**
   ```bash
   which render
   ls -la /usr/local/bin/render
   ```