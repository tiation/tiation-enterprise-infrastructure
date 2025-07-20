#!/bin/bash

# Tiation Ansible Enterprise Setup Script
# This script initializes the enterprise-grade Ansible automation platform

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ANSIBLE_VERSION="4.0.0"
PYTHON_VERSION="3.9"

# Functions
log() {
    echo -e "${CYAN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Banner
display_banner() {
    echo -e "${MAGENTA}"
    cat << 'EOF'
    ████████ ██   █████  ████████ ██  ██████  ███    ██ 
       ██    ██  ██   ██    ██    ██ ██    ██ ████   ██ 
       ██    ██  ███████    ██    ██ ██    ██ ██ ██  ██ 
       ██    ██  ██   ██    ██    ██ ██    ██ ██  ██ ██ 
       ██    ██  ██   ██    ██    ██  ██████  ██   ████ 
    
    🚀 ANSIBLE ENTERPRISE SETUP 🚀
    Enterprise-grade automation platform initialization
EOF
    echo -e "${NC}"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check Python version
    if command -v python3 &> /dev/null; then
        python_version=$(python3 --version | cut -d' ' -f2)
        success "Python ${python_version} found"
    else
        error "Python 3 is required but not installed"
        exit 1
    fi
    
    # Check pip
    if command -v pip3 &> /dev/null; then
        success "pip3 found"
    else
        error "pip3 is required but not installed"
        exit 1
    fi
    
    # Check git
    if command -v git &> /dev/null; then
        success "Git found"
    else
        error "Git is required but not installed"
        exit 1
    fi
    
    # Check Docker (optional)
    if command -v docker &> /dev/null; then
        success "Docker found"
    else
        warning "Docker not found - some features may be limited"
    fi
    
    # Check SSH
    if command -v ssh &> /dev/null; then
        success "SSH found"
    else
        error "SSH is required but not installed"
        exit 1
    fi
}

# Install Python dependencies
install_python_dependencies() {
    log "Installing Python dependencies..."
    
    # Upgrade pip
    python3 -m pip install --upgrade pip
    
    # Install requirements
    if [[ -f "${PROJECT_ROOT}/requirements.txt" ]]; then
        python3 -m pip install -r "${PROJECT_ROOT}/requirements.txt"
        success "Python dependencies installed"
    else
        error "requirements.txt not found"
        exit 1
    fi
}

# Install Ansible collections
install_ansible_collections() {
    log "Installing Ansible collections..."
    
    if [[ -f "${PROJECT_ROOT}/requirements.yml" ]]; then
        ansible-galaxy install -r "${PROJECT_ROOT}/requirements.yml" --force
        success "Ansible collections installed"
    else
        error "requirements.yml not found"
        exit 1
    fi
}

# Setup directories
setup_directories() {
    log "Setting up directory structure..."
    
    local dirs=(
        "logs"
        "tmp"
        "vault"
        "playbooks/tasks"
        "playbooks/handlers"
        "roles/custom"
        "inventories/local"
        "inventories/testing"
        "library/custom"
        "filter_plugins/custom"
        "lookup_plugins/custom"
        "docs/images"
        "tests/integration"
        "tests/unit"
        "scripts/deployment"
        "scripts/maintenance"
        "scripts/monitoring"
        ".github/workflows"
        ".github/ISSUE_TEMPLATE"
        ".github/PULL_REQUEST_TEMPLATE"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "${PROJECT_ROOT}/${dir}"
    done
    
    success "Directory structure created"
}

# Setup configuration files
setup_configuration() {
    log "Setting up configuration files..."
    
    # Create local inventory if it doesn't exist
    if [[ ! -f "${PROJECT_ROOT}/inventories/local/hosts.yml" ]]; then
        cat > "${PROJECT_ROOT}/inventories/local/hosts.yml" << 'EOF'
---
all:
  hosts:
    localhost:
      ansible_connection: local
      ansible_python_interpreter: "{{ ansible_playbook_python }}"
EOF
        success "Local inventory created"
    fi
    
    # Create .env file
    if [[ ! -f "${PROJECT_ROOT}/.env" ]]; then
        cat > "${PROJECT_ROOT}/.env" << 'EOF'
# Tiation Ansible Enterprise Environment Configuration
# Copy this file to .env and configure your values

# GitHub Configuration
GITHUB_TOKEN=your_github_token_here
GITHUB_ORG=tiaastor

# Docker Configuration
DOCKER_USERNAME=your_docker_username
DOCKER_PASSWORD=your_docker_password

# Ansible Configuration
ANSIBLE_VAULT_PASSWORD=your_vault_password_here
ANSIBLE_HOST_KEY_CHECKING=False
ANSIBLE_STDOUT_CALLBACK=yaml
ANSIBLE_GATHERING=smart

# Monitoring Configuration
SLACK_WEBHOOK_URL=your_slack_webhook_url
GRAFANA_ADMIN_PASSWORD=your_grafana_password

# Backup Configuration
BACKUP_S3_BUCKET=your_backup_bucket
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key

# SSL Configuration
SSL_CERT_PATH=/path/to/ssl/cert
SSL_KEY_PATH=/path/to/ssl/key
EOF
        success ".env file created"
    fi
    
    # Create gitignore
    if [[ ! -f "${PROJECT_ROOT}/.gitignore" ]]; then
        cat > "${PROJECT_ROOT}/.gitignore" << 'EOF'
# Ansible
*.retry
.ansible/
ansible.log
.vault_pass
.vault_password*

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Environment
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Temporary files
tmp/
temp/
.tmp/

# Secrets
secrets/
private/
*.key
*.pem
*.p12
*.pfx
EOF
        success ".gitignore created"
    fi
}

# Setup vault
setup_vault() {
    log "Setting up Ansible Vault..."
    
    # Create vault directory
    mkdir -p "${PROJECT_ROOT}/vault"
    
    # Create vault password file
    if [[ ! -f "${HOME}/.ansible/vault_password" ]]; then
        mkdir -p "${HOME}/.ansible"
        read -s -p "Enter vault password: " vault_pass
        echo
        echo "${vault_pass}" > "${HOME}/.ansible/vault_password"
        chmod 600 "${HOME}/.ansible/vault_password"
        success "Vault password file created"
    fi
    
    # Create sample vault file
    if [[ ! -f "${PROJECT_ROOT}/vault/secrets.yml" ]]; then
        cat > "${PROJECT_ROOT}/vault/secrets.yml" << 'EOF'
---
# Sample encrypted secrets file
# To encrypt: ansible-vault encrypt vault/secrets.yml
# To edit: ansible-vault edit vault/secrets.yml

vault_mysql_root_password: "super_secure_password"
vault_mysql_replication_user: "replication_user"
vault_mysql_replication_password: "replication_password"
vault_grafana_admin_password: "admin_password"
vault_monitoring_slack_webhook: "https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"
vault_ssl_certificate: |
  -----BEGIN CERTIFICATE-----
  YOUR_SSL_CERTIFICATE_HERE
  -----END CERTIFICATE-----
vault_ssl_private_key: |
  -----BEGIN PRIVATE KEY-----
  YOUR_SSL_PRIVATE_KEY_HERE
  -----END PRIVATE KEY-----
EOF
        success "Sample vault file created"
    fi
}

# Setup GitHub Actions
setup_github_actions() {
    log "Setting up GitHub Actions..."
    
    mkdir -p "${PROJECT_ROOT}/.github/workflows"
    
    cat > "${PROJECT_ROOT}/.github/workflows/ci.yml" << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [3.8, 3.9, '3.10']
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    
    - name: Run ansible-lint
      run: |
        ansible-lint playbooks/
    
    - name: Run yamllint
      run: |
        yamllint .
    
    - name: Test playbooks syntax
      run: |
        ansible-playbook --syntax-check playbooks/site.yml
    
    - name: Run molecule tests
      run: |
        molecule test
      env:
        MOLECULE_DEBUG: true

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./docs
        cname: tiation-ansible-enterprise.tiation.com
EOF
    
    success "GitHub Actions workflow created"
}

# Setup documentation
setup_documentation() {
    log "Setting up documentation..."
    
    mkdir -p "${PROJECT_ROOT}/docs"
    
    # Create docs index
    cat > "${PROJECT_ROOT}/docs/index.md" << 'EOF'
# Tiation Ansible Enterprise Documentation

Welcome to the comprehensive documentation for Tiation Ansible Enterprise - your enterprise-grade automation platform.

## Quick Navigation

- [Getting Started](getting-started.md)
- [Architecture](architecture.md)
- [Installation](installation.md)
- [Configuration](configuration.md)
- [Playbooks](playbooks.md)
- [Roles](roles.md)
- [Security](security.md)
- [Troubleshooting](troubleshooting.md)

## Overview

Tiation Ansible Enterprise provides a complete automation solution for modern infrastructure management, featuring:

- 🚀 **Automated Deployments**: Streamlined CI/CD pipelines
- 🔒 **Security Hardening**: Enterprise-grade security configurations
- 📊 **Monitoring & Observability**: Comprehensive system monitoring
- 🎨 **Dark Neon Theme**: Consistent branding across all platforms
- 🌐 **Multi-Cloud Support**: AWS, Azure, GCP, and hybrid deployments

## Architecture

```mermaid
graph TB
    A[Ansible Control Node] --> B[Web Servers]
    A --> C[Database Servers]
    A --> D[Load Balancers]
    A --> E[Monitoring Servers]
    A --> F[Container Hosts]
    
    B --> G[Application Layer]
    C --> H[Data Layer]
    D --> I[Traffic Management]
    E --> J[Observability]
    F --> K[Container Services]
```

## Getting Started

1. **Prerequisites**: Ensure you have Python 3.9+, Ansible 4.0+, and Git installed
2. **Installation**: Run the setup script: `./scripts/setup-enterprise.sh`
3. **Configuration**: Edit your inventory files and vault secrets
4. **Deployment**: Execute your first playbook: `ansible-playbook playbooks/site.yml`

## Support

For support, please check our documentation or create an issue in the GitHub repository.
EOF
    
    success "Documentation index created"
}

# Run tests
run_tests() {
    log "Running initial tests..."
    
    # Test ansible installation
    if ansible --version &> /dev/null; then
        success "Ansible installation verified"
    else
        error "Ansible installation failed"
        exit 1
    fi
    
    # Test playbook syntax
    if ansible-playbook --syntax-check "${PROJECT_ROOT}/playbooks/site.yml" &> /dev/null; then
        success "Playbook syntax verified"
    else
        warning "Playbook syntax check failed - this is normal for initial setup"
    fi
    
    # Test inventory
    if ansible-inventory --list -i "${PROJECT_ROOT}/inventories/local/hosts.yml" &> /dev/null; then
        success "Inventory configuration verified"
    else
        error "Inventory configuration failed"
        exit 1
    fi
}

# Main execution
main() {
    display_banner
    
    info "Starting Tiation Ansible Enterprise setup..."
    
    check_prerequisites
    setup_directories
    setup_configuration
    install_python_dependencies
    install_ansible_collections
    setup_vault
    setup_github_actions
    setup_documentation
    run_tests
    
    echo -e "\n${GREEN}🎉 Setup completed successfully!${NC}\n"
    
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "1. Configure your environment variables in ${YELLOW}.env${NC}"
    echo -e "2. Update your inventory files in ${YELLOW}inventories/${NC}"
    echo -e "3. Configure your vault secrets in ${YELLOW}vault/secrets.yml${NC}"
    echo -e "4. Run your first playbook: ${YELLOW}ansible-playbook playbooks/site.yml${NC}"
    
    echo -e "\n${CYAN}Documentation:${NC}"
    echo -e "- Local docs: ${YELLOW}docs/index.md${NC}"
    echo -e "- GitHub Pages: ${YELLOW}https://tiaastor.github.io/tiation-ansible-enterprise/${NC}"
    
    echo -e "\n${CYAN}GitHub Repository:${NC}"
    echo -e "- Repository: ${YELLOW}https://github.com/tiaastor/tiation-ansible-enterprise${NC}"
    echo -e "- Issues: ${YELLOW}https://github.com/tiaastor/tiation-ansible-enterprise/issues${NC}"
    
    echo -e "\n${MAGENTA}🚀 Happy Automating with Tiation Ansible Enterprise!${NC}"
}

# Execute main function
main "$@"
