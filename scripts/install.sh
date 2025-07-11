#!/bin/bash

# Claude Code MCP Configuration Installer
# This script automates the installation and configuration of Claude Code with MCPs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

# Header
echo "================================"
echo "Claude Code MCP Configuration"
echo "Automated Installer"
echo "================================"
echo ""

# Check prerequisites
echo "Checking prerequisites..."

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_success "Node.js installed: $NODE_VERSION"
    
    # Check version
    MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    if [ $MAJOR_VERSION -lt 20 ]; then
        print_error "Node.js version 20+ required (found $NODE_VERSION)"
        exit 1
    fi
else
    print_error "Node.js not found. Please install Node.js v20+"
    exit 1
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_success "npm installed: $NPM_VERSION"
else
    print_error "npm not found"
    exit 1
fi

echo ""

# Install Claude Code
echo "Installing Claude Code..."
if npm list -g @anthropic/claude-code &> /dev/null; then
    print_warning "Claude Code already installed"
else
    npm install -g @anthropic/claude-code
    print_success "Claude Code installed successfully"
fi

echo ""

# Create directories
echo "Creating configuration directories..."
mkdir -p ~/.claude/.taskmaster-global
print_success "Created ~/.claude/.taskmaster-global"

echo ""

# Copy configuration files
echo "Setting up configuration files..."

# Main configuration
if [ -f ~/.claude.json ]; then
    print_warning "~/.claude.json already exists. Creating backup..."
    cp ~/.claude.json ~/.claude.json.backup.$(date +%Y%m%d_%H%M%S)
fi

cp config/claude.json ~/.claude.json
print_success "Copied claude.json configuration"

# TaskMaster configuration
if [ -f ~/.claude/.taskmaster-global/config.json ]; then
    print_warning "TaskMaster config exists. Creating backup..."
    cp ~/.claude/.taskmaster-global/config.json ~/.claude/.taskmaster-global/config.json.backup.$(date +%Y%m%d_%H%M%S)
fi

cp config/taskmaster-global-config.json ~/.claude/.taskmaster-global/config.json
print_success "Copied TaskMaster configuration"

# CLAUDE.md
if [ -f ~/.claude/CLAUDE.md ]; then
    print_warning "CLAUDE.md exists. Creating backup..."
    cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)
fi

cp config/CLAUDE.md ~/.claude/CLAUDE.md
print_success "Copied global instructions (CLAUDE.md)"

echo ""

# Setup environment variables
echo "Setting up environment variables..."

# Detect shell
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

print_warning "Detected shell configuration file: $SHELL_RC"

# Check if already configured
if grep -q "CLAUDECODE=1" "$SHELL_RC" 2>/dev/null; then
    print_warning "Environment variables already configured"
else
    echo "" >> "$SHELL_RC"
    echo "# Claude Code Configuration" >> "$SHELL_RC"
    echo "export CLAUDECODE=1" >> "$SHELL_RC"
    echo "export CLAUDE_CODE_ENTRYPOINT=cli" >> "$SHELL_RC"
    echo "export TASKMASTER_DEFAULT_PROVIDER=claude-code" >> "$SHELL_RC"
    echo 'export TASKMASTER_GLOBAL_CONFIG=~/.claude/.taskmaster-global/config.json' >> "$SHELL_RC"
    print_success "Added environment variables to $SHELL_RC"
fi

echo ""

# Test installation
echo "Testing installation..."

# Test Claude Code
if command -v claude &> /dev/null; then
    print_success "Claude Code command available"
else
    print_warning "Claude Code command not found in PATH"
    print_warning "You may need to restart your terminal or run: source $SHELL_RC"
fi

echo ""

# Final instructions
echo "================================"
echo "Installation Complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source $SHELL_RC"
echo "2. Run 'claude' to start Claude Code"
echo "3. Test Context7 with: \"How to use React hooks? use context7\""
echo "4. Test TaskMaster with: /models"
echo ""
echo "For more information, see:"
echo "- README.md for overview"
echo "- docs/INSTALLATION.md for detailed setup"
echo "- docs/TROUBLESHOOTING.md if you encounter issues"
echo ""

# Optional: Test immediately
read -p "Would you like to test the installation now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Sourcing environment variables..."
    source "$SHELL_RC"
    
    echo "Launching Claude Code..."
    echo "Try typing: /models"
    echo "Or: \"What is React? use context7\""
    echo ""
    claude
fi