#!/bin/bash

# Test script to verify Ansible Enterprise setup
set -e

echo "🧪 Testing Tiation Ansible Enterprise Setup"
echo "==========================================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

# Test Python version
echo "Testing Python version..."
python_version=$(python3 --version | cut -d' ' -f2)
if [[ "$python_version" > "3.10" ]]; then
    success "Python version: $python_version"
else
    error "Python version $python_version is too old (need 3.10+)"
fi

# Test Ansible version
echo "Testing Ansible version..."
ansible_version=$(ansible --version | head -1 | cut -d' ' -f3 | tr -d '[]')
if [[ "$ansible_version" > "2.15" ]]; then
    success "Ansible version: $ansible_version"
else
    error "Ansible version $ansible_version is too old (need 2.15+)"
fi

# Test Ansible configuration
echo "Testing Ansible configuration..."
if ansible-config dump | grep -q "DEFAULT_INVENTORY"; then
    success "Ansible configuration loaded"
else
    error "Ansible configuration not loaded"
fi

# Test inventory
echo "Testing inventory..."
if ansible-inventory --list -i inventories/production/hosts.yml >/dev/null 2>&1; then
    success "Inventory file valid"
else
    error "Inventory file invalid"
fi

# Test playbook syntax
echo "Testing playbook syntax..."
if ansible-playbook --syntax-check playbooks/site.yml >/dev/null 2>&1; then
    success "Main playbook syntax valid"
else
    error "Main playbook syntax invalid"
fi

# Test GitHub setup playbook
echo "Testing GitHub setup playbook..."
if ansible-playbook --syntax-check playbooks/github-setup.yml >/dev/null 2>&1; then
    success "GitHub setup playbook syntax valid"
else
    error "GitHub setup playbook syntax invalid"
fi

# Test roles
echo "Testing installed roles..."
role_count=$(ansible-galaxy role list | grep -c "geerlingguy" || echo "0")
if [[ $role_count -gt 0 ]]; then
    success "Ansible roles installed: $role_count"
else
    error "No Ansible roles installed"
fi

# Test collections
echo "Testing installed collections..."
collection_count=$(ansible-galaxy collection list | grep -c "community\|amazon\|azure\|google" || echo "0")
if [[ $collection_count -gt 0 ]]; then
    success "Ansible collections installed: $collection_count"
else
    error "No Ansible collections installed"
fi

# Test virtual environment
echo "Testing virtual environment..."
if [[ "$VIRTUAL_ENV" ]]; then
    success "Virtual environment active: $VIRTUAL_ENV"
else
    error "Virtual environment not active"
fi

# Test dark neon theme role
echo "Testing dark neon theme role..."
if [[ -d "roles/tiation-dark-neon-theme" ]]; then
    success "Dark neon theme role exists"
else
    error "Dark neon theme role not found"
fi

# Test documentation
echo "Testing documentation..."
if [[ -f "docs/architecture.md" && -f "docs/index.md" ]]; then
    success "Documentation files exist"
else
    error "Documentation files missing"
fi

echo
echo "🎉 All tests passed! Tiation Ansible Enterprise is ready to use."
echo
echo "📋 Summary:"
echo "- Python: $python_version"
echo "- Ansible: $ansible_version"
echo "- Roles: $role_count"
echo "- Collections: $collection_count"
echo "- Virtual environment: $(basename $VIRTUAL_ENV)"
echo
echo "🚀 Next steps:"
echo "1. Configure your GitHub token in .env file"
echo "2. Update inventory files with your servers"
echo "3. Run: ansible-playbook playbooks/github-setup.yml"
echo "4. Run: ansible-playbook playbooks/site.yml"
