#!/usr/bin/env python3
"""
Render CLI - Python script to interact with Render API
"""

import os
import sys
import json
from datetime import datetime

# Check for requests dependency
try:
    import requests
except ImportError:
    print("Error: 'requests' library is not installed")
    print("Install it using: pip3 install requests")
    sys.exit(1)

class RenderCLI:
    def __init__(self):
        self.api_key = os.getenv('RENDER_API_KEY')
        if not self.api_key:
            print("Error: RENDER_API_KEY environment variable is not set")
            print("Set it using: export RENDER_API_KEY='your-api-key'")
            sys.exit(1)
        
        self.base_url = "https://api.render.com/v1"
        self.headers = {
            'Authorization': f'Bearer {self.api_key}',
            'Content-Type': 'application/json'
        }
    
    def get_services(self):
        """List all services"""
        response = requests.get(f"{self.base_url}/services", headers=self.headers)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error: {response.status_code} - {response.text}")
            return None
    
    def get_service_details(self, service_id):
        """Get detailed service information"""
        response = requests.get(f"{self.base_url}/services/{service_id}", headers=self.headers)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error: {response.status_code} - {response.text}")
            return None
    
    def get_deployments(self, service_id):
        """Get service deployments"""
        response = requests.get(f"{self.base_url}/services/{service_id}/deploys", headers=self.headers)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Error: {response.status_code} - {response.text}")
            return None
    
    def format_service_list(self, services_data):
        """Format services list for display"""
        if not services_data:
            return "No services found"
        
        output = []
        output.append("Render Services:")
        output.append("=" * 80)
        
        for item in services_data:
            service = item.get('service', {})
            service_id = service.get('id', 'N/A')
            name = service.get('name', 'Unnamed')
            service_type = service.get('type', 'unknown')
            status = service.get('suspended', 'unknown')
            updated = service.get('updatedAt', '')
            
            # Parse date
            if updated:
                try:
                    dt = datetime.fromisoformat(updated.replace('Z', '+00:00'))
                    updated_str = dt.strftime('%Y-%m-%d %H:%M')
                except:
                    updated_str = updated
            
            details = service.get('serviceDetails', {})
            url = details.get('url', 'No URL')
            plan = details.get('plan', 'unknown')
            region = details.get('region', 'unknown')
            
            output.append(f"Name: {name}")
            output.append(f"ID: {service_id}")
            output.append(f"Type: {service_type}")
            output.append(f"Status: {status}")
            output.append(f"URL: {url}")
            output.append(f"Plan: {plan} | Region: {region}")
            output.append(f"Last Updated: {updated_str}")
            output.append("-" * 80)
        
        return "\n".join(output)
    
    def format_service_details(self, service_data):
        """Format detailed service information"""
        if not service_data:
            return "Service not found"
        
        output = []
        output.append("Service Details:")
        output.append("=" * 80)
        
        name = service_data.get('name', 'Unnamed')
        service_id = service_data.get('id', 'N/A')
        service_type = service_data.get('type', 'unknown')
        status = service_data.get('suspended', 'unknown')
        created = service_data.get('createdAt', '')
        updated = service_data.get('updatedAt', '')
        repo = service_data.get('repo', 'No repository')
        branch = service_data.get('branch', 'N/A')
        auto_deploy = service_data.get('autoDeploy', 'no')
        
        details = service_data.get('serviceDetails', {})
        url = details.get('url', 'No URL')
        plan = details.get('plan', 'unknown')
        region = details.get('region', 'unknown')
        runtime = details.get('runtime', 'unknown')
        instances = details.get('numInstances', 1)
        ssh_address = details.get('sshAddress', 'N/A')
        
        # Parse dates
        for date_str, label in [(created, 'Created'), (updated, 'Updated')]:
            if date_str:
                try:
                    dt = datetime.fromisoformat(date_str.replace('Z', '+00:00'))
                    output.append(f"{label}: {dt.strftime('%Y-%m-%d %H:%M:%S')}")
                except:
                    output.append(f"{label}: {date_str}")
        
        output.append(f"Name: {name}")
        output.append(f"ID: {service_id}")
        output.append(f"Type: {service_type}")
        output.append(f"Status: {status}")
        output.append(f"URL: {url}")
        output.append(f"Repository: {repo}")
        output.append(f"Branch: {branch}")
        output.append(f"Auto-deploy: {auto_deploy}")
        output.append(f"Plan: {plan} | Region: {region}")
        output.append(f"Runtime: {runtime} | Instances: {instances}")
        output.append(f"SSH Address: {ssh_address}")
        
        # Build details
        env_details = details.get('envSpecificDetails', {})
        if env_details:
            output.append("\nBuild Configuration:")
            for key, value in env_details.items():
                output.append(f"  {key}: {value}")
        
        return "\n".join(output)

def print_help():
    print("Render CLI - Manage your Render services")
    print("=" * 50)
    print("Usage: render <command> [options]")
    print("\nCommands:")
    print("  services list                    List all services")
    print("  services show <service-id>       Show service details")
    print("  deployments <service-id>         List service deployments")
    print("  help                             Show this help message")
    print("  version                          Show version information")
    print("\nExamples:")
    print("  render services list")
    print("  render services show srv-abc123")
    print("  render deployments srv-abc123")
    print("\nEnvironment Variables:")
    print("  RENDER_API_KEY                   Your Render API key (required)")

def main():
    if len(sys.argv) < 2:
        print_help()
        return
    
    command = sys.argv[1]
    
    if command in ["help", "--help", "-h"]:
        print_help()
        return
    
    if command in ["version", "--version", "-v"]:
        print("Render CLI v1.0.0")
        print("Python-based Render API client")
        return
    
    cli = RenderCLI()
    command = sys.argv[1]
    
    if command == "services" and len(sys.argv) > 2:
        subcommand = sys.argv[2]
        
        if subcommand == "list":
            services = cli.get_services()
            if services:
                print(cli.format_service_list(services))
        
        elif subcommand == "show" and len(sys.argv) > 3:
            service_id = sys.argv[3]
            service = cli.get_service_details(service_id)
            if service:
                print(cli.format_service_details(service))
        
        else:
            print(f"Unknown subcommand: {subcommand}")
    
    elif command == "deployments" and len(sys.argv) > 2:
        service_id = sys.argv[2]
        deployments = cli.get_deployments(service_id)
        if deployments:
            print("Deployments:")
            print("=" * 80)
            for item in deployments:
                deploy = item.get('deploy', {})
                deploy_id = deploy.get('id', 'N/A')
                status = deploy.get('status', 'unknown')
                trigger = deploy.get('trigger', 'unknown')
                created = deploy.get('createdAt', '')
                
                commit = deploy.get('commit', {})
                commit_msg = commit.get('message', 'No message')
                
                if created:
                    try:
                        dt = datetime.fromisoformat(created.replace('Z', '+00:00'))
                        created_str = dt.strftime('%Y-%m-%d %H:%M')
                    except:
                        created_str = created
                
                print(f"ID: {deploy_id}")
                print(f"Status: {status} | Trigger: {trigger}")
                print(f"Created: {created_str}")
                print(f"Commit: {commit_msg[:80]}...")
                print("-" * 80)
    
    else:
        print(f"Unknown command: {command}")

if __name__ == "__main__":
    main()