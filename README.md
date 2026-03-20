# Render CLI for Minis/iSH

A Python-based Render CLI that works in the Minis/iSH environment (Alpine Linux on iOS).

## Installation

The Render CLI has been installed and configured for you. The following components are available:

1. **`render` command** - Available at `/usr/local/bin/render`
2. **Python script** - Available at `/var/minis/workspace/render_cli.py`
3. **Setup script** - Available at `/var/minis/workspace/setup_render_cli.sh`

## Setup

Your `RENDER_API_KEY` environment variable is already set. You can verify this by running:

```bash
echo $RENDER_API_KEY | head -c 10
```

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
- The CLI is designed to work within the iSH/Alpine Linux environment constraints
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

3. **Run setup script:**
   ```bash
   sh /var/minis/workspace/setup_render_cli.sh
   ```