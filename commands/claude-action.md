# Claude Action Command

## Description
Global command to interact with Claude Code Actions on GitHub. This command allows you to create issues and PR comments with @claude mentions directly from the command line.

## Usage
```bash
claude-action <command> [options]
```

## Commands

### issue
Create an issue with @claude mention
```bash
claude-action issue <title> <body>
```

### implement
Create an issue asking Claude to implement a feature
```bash
claude-action implement <description>
```

### fix
Create an issue asking Claude to fix a bug
```bash
claude-action fix <description>
```

### review
Ask Claude to review a PR
```bash
claude-action review <pr-number>
```

### pr-comment
Comment on a PR with @claude mention
```bash
claude-action pr-comment <pr-number> <message>
```

## Examples

```bash
# Ask Claude to implement a new feature
claude-action implement "Add user authentication with JWT tokens"

# Ask Claude to fix a bug
claude-action fix "TypeError in dashboard component when user is null"

# Ask Claude to review PR #123
claude-action review 123

# Add a custom comment to PR #456
claude-action pr-comment 456 "Can you improve the error handling in this function?"

# Create a custom issue
claude-action issue "Performance Optimization" "Please analyze and improve the performance of the data processing pipeline"
```

## Requirements
- GitHub CLI (`gh`) must be installed and authenticated
- Must be run from within a git repository
- Repository must have Claude Code Actions configured

## Installation

### Option 1: Global Installation (Recommended)
```bash
# Copy to ~/.claude/commands/
cp commands/claude-action.md ~/.claude/commands/

# Copy the script to a location in your PATH
sudo cp scripts/claude-action /usr/local/bin/
sudo chmod +x /usr/local/bin/claude-action
```

### Option 2: Local Installation
```bash
# Add to your PATH in ~/.bashrc or ~/.zshrc
echo 'export PATH="$HOME/claude-config/scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Make executable
chmod +x scripts/claude-action
```

## How It Works

1. **Authentication**: Checks if GitHub CLI is installed and authenticated
2. **Repository Detection**: Automatically detects the current repository from git config
3. **Issue/PR Creation**: Uses GitHub CLI to create issues or comments with @claude mentions
4. **Claude Response**: Claude will automatically respond to the mention in the issue or PR

## Troubleshooting

### "gh: command not found"
Install GitHub CLI:
```bash
# Ubuntu/Debian
sudo apt install gh

# macOS
brew install gh

# Or download from https://cli.github.com/
```

### "Not authenticated with GitHub"
Run:
```bash
gh auth login
```

### "Not in a git repository"
Make sure you're running the command from within a git repository with a GitHub remote.

### Claude not responding
Ensure your repository has Claude Code Actions enabled. Check the Actions tab in your GitHub repository.