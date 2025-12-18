# Quick Start Guide

Get up and running with LiteLLM Statusline in under 5 minutes.

## 🚀 Installation

### macOS

```bash
# One command - installs everything
curl -fsSL https://raw.githubusercontent.com/leehack/cc-litellm-statusline/main/install-statusline-cross-platform.sh | bash
```

### Linux

```bash
# Works on Ubuntu, Debian, Fedora, Arch
curl -fsSL https://raw.githubusercontent.com/leehack/cc-litellm-statusline/main/install-statusline-cross-platform.sh | bash
```

### Windows (WSL/Git Bash)

```bash
curl -fsSL https://raw.githubusercontent.com/leehack/cc-litellm-statusline/main/install-statusline-cross-platform.sh | bash
```

### Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/leehack/cc-litellm-statusline/main/install-statusline.ps1 | iex
```

## ⚙️ Setup

### 1. Get Your LiteLLM Details

Contact your LiteLLM administrator or check your LiteLLM dashboard for:
- Your LiteLLM instance URL
- Your API key

### 2. Set Environment Variables

**macOS/Linux (bash):**

```bash
echo 'export LITELLM_BASE_URL="https://your-litellm-instance.com"' >> ~/.bashrc
echo 'export LITELLM_API_KEY="sk-your-key-here"' >> ~/.bashrc
source ~/.bashrc
```

**macOS (zsh):**

```bash
echo 'export LITELLM_BASE_URL="https://your-litellm-instance.com"' >> ~/.zshrc
echo 'export LITELLM_API_KEY="sk-your-key-here"' >> ~/.zshrc
source ~/.zshrc
```

**Windows (PowerShell - permanent):**

```powershell
[System.Environment]::SetEnvironmentVariable('LITELLM_BASE_URL', 'https://your-litellm-instance.com', 'User')
[System.Environment]::SetEnvironmentVariable('LITELLM_API_KEY', 'sk-your-key-here', 'User')
```

**Windows (PowerShell - current session):**

```powershell
$env:LITELLM_BASE_URL = 'https://your-litellm-instance.com'
$env:LITELLM_API_KEY = 'sk-your-key-here'
```

### 3. Restart Claude Code

Close and reopen Claude Code to see your new statusline!

## ✅ Verify Installation

Test the statusline manually:

```bash
echo '{"workspace":{"current_dir":"'$(pwd)'"}}' | ~/.claude/cc-litellm-statusline.sh
```

You should see output like:

```
➜ my-project git:(main) 💰$12.45/$100.00 (12%)
```

## 🎨 What You'll See

- **➜** - Ready indicator (always green)
- **my-project** - Current directory name (cyan)
- **git:(main)** - Git branch name (blue/red)
- **✗** - Dirty repository indicator (yellow)
- **💰$12.45/$100.00 (12%)** - Budget tracking (color-coded)

## 🔧 Common Issues

### "command not found: jq"

Install dependencies:

**macOS:**

```bash
brew install jq bc
```

**Ubuntu/Debian:**

```bash
sudo apt install jq bc
```

### Budget info not showing

1. Check environment variables are set:

   ```bash
   echo $LITELLM_BASE_URL
   echo $LITELLM_API_KEY
   ```

   Both must be set for budget tracking to work.

2. Verify API access:

   ```bash
   curl -H "Authorization: Bearer $LITELLM_API_KEY" \
     "${LITELLM_BASE_URL}/key/info"
   ```

### Statusline not appearing

1. Verify configuration:

   ```bash
   cat ~/.claude/settings.json
   ```

   Should contain:

   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "/path/to/cc-litellm-statusline.sh"
     }
   }
   ```

   **Note:** Field must be `statusLine` (capital L) with `type: "command"`

2. Check script permissions:

   ```bash
   ls -la ~/.claude/cc-litellm-statusline.sh
   ```

   Should show: `-rwxr-xr-x` (executable)

## 🎯 Next Steps

- [Customize colors](README.md#custom-colors)
- [Change API endpoint](README.md#api-endpoint)
- [Adjust refresh rate](README.md#refresh-interval)
- [Contribute improvements](CONTRIBUTING.md)

## 📚 Full Documentation

For detailed information, see the [README](README.md).

## 💡 Tips

1. **Performance**: The statusline caches API calls for 2 seconds
2. **Privacy**: API key is only stored in environment variables
3. **Offline**: Works without LiteLLM API (just won't show budget)
4. **Git**: Automatically detects git repositories

## 🆘 Getting Help

- Check [Troubleshooting](README.md#troubleshooting) in README
- Open an [issue](../../issues) on GitHub
- Read the [full documentation](README.md)

## ✨ Enjoy Your Enhanced Statusline

You now have a beautiful, informative statusline that shows your working directory, git status, and LiteLLM budget at a glance.
