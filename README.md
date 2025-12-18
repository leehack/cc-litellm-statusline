# LiteLLM Statusline for Claude Code

Beautiful, informative statusline for Claude Code with Git integration and LiteLLM budget tracking.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)

## ✨ Features

- 📁 **Current directory** name display
- 🌿 **Git branch** with clean/dirty status indicator
- 💰 **LiteLLM budget tracking** with color-coded warnings:
  - 🟢 Green: < 75% budget used
  - 🟡 Yellow: 75-90% budget used
  - 🔴 Red: > 90% budget used
- 🎨 **Dimmed colors** for non-intrusive display
- ⚡ **Fast and lightweight** with minimal overhead

## 📸 Preview

```
➜ my-project git:(main) 💰$12.45/$100.00 (12%)
```

## 🚀 Quick Installation

The installer will:
- ✅ Install required dependencies (jq, bc, curl, git)
- ✅ Create the statusline script in `~/.claude/`
- ✅ **Automatically configure** `~/.claude/settings.json`
- ✅ Backup existing settings before making changes

### One-Liner Installation

**macOS & Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/leehack/cc-litellm-statusline/main/install-statusline-cross-platform.sh | bash
```

**Windows (PowerShell):**

```powershell
iwr -useb https://raw.githubusercontent.com/leehack/cc-litellm-statusline/main/install-statusline.ps1 | iex
```

**Windows (WSL/Git Bash):**

```bash
curl -fsSL https://raw.githubusercontent.com/leehack/cc-litellm-statusline/main/install-statusline-cross-platform.sh | bash
```

### Post-Installation

After running the installer, you only need to:

1. Set your `LITELLM_BASE_URL` and `LITELLM_API_KEY` environment variables (see instructions below)
2. Restart Claude Code

That's it! The installer handles all the configuration automatically.

## 📋 Prerequisites

The installer will automatically install these if missing:

- `jq` - JSON parsing
- `bc` - Calculations (Linux/macOS)
- `curl` - API requests
- `git` - Git integration

## 🔧 Manual Installation

<details>
<summary>Click to expand manual installation steps</summary>

### 1. Install Dependencies

**macOS:**

```bash
brew install jq bc curl git
```

**Ubuntu/Debian:**

```bash
sudo apt update && sudo apt install -y jq bc curl git
```

**Fedora:**

```bash
sudo dnf install -y jq bc curl git
```

**Arch Linux:**

```bash
sudo pacman -S --noconfirm jq bc curl git
```

**Windows (Chocolatey):**

```powershell
choco install jq curl git -y
```

### 2. Download Script

```bash
mkdir -p ~/.claude
curl -fsSL https://raw.githubusercontent.com/leehack/cc-litellm-statusline/main/scripts/cc-litellm-statusline.sh \
  -o ~/.claude/cc-litellm-statusline.sh
chmod +x ~/.claude/cc-litellm-statusline.sh
```

### 3. Configure Claude Code Settings

Edit or create `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "/Users/yourusername/.claude/cc-litellm-statusline.sh"
  }
}
```

**Note:**
- Use the full absolute path to the script
- Field name must be `statusLine` (capital L)
- Must include `type: "command"`

### 4. Configure Environment

**Unix (bash):**

```bash
echo 'export LITELLM_BASE_URL="https://your-litellm-instance.com"' >> ~/.bashrc
echo 'export LITELLM_API_KEY="your-api-key-here"' >> ~/.bashrc
source ~/.bashrc
```

**Unix (zsh):**

```bash
echo 'export LITELLM_BASE_URL="https://your-litellm-instance.com"' >> ~/.zshrc
echo 'export LITELLM_API_KEY="your-api-key-here"' >> ~/.zshrc
source ~/.zshrc
```

**Windows (PowerShell):**

```powershell
[System.Environment]::SetEnvironmentVariable('LITELLM_BASE_URL', 'https://your-litellm-instance.com', 'User')
[System.Environment]::SetEnvironmentVariable('LITELLM_API_KEY', 'your-api-key-here', 'User')
```

</details>

## ⚙️ Configuration

### Environment Variables

The statusline requires two environment variables:

- **`LITELLM_BASE_URL`** (required): Your LiteLLM instance URL (e.g., `https://your-litellm-instance.com`)
- **`LITELLM_API_KEY`** (required): Your LiteLLM API key

The script will call `${LITELLM_BASE_URL}/key/info` to fetch budget information.

### Refresh Interval

Edit `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/cc-litellm-statusline.sh",
    "refreshInterval": 5000
  }
}
```

### Custom Colors

The script uses ANSI color codes. Customize in `cc-litellm-statusline.sh`:

```bash
# Git branch colors (lines 22-25)
\033[2;34;1m  # Dimmed blue
\033[2;31m    # Dimmed red

# Budget colors (lines 56-61)
\033[2;32m    # Green (< 75%)
\033[2;33m    # Yellow (75-90%)
\033[2;31m    # Red (> 90%)
```

## 🔍 Troubleshooting

<details>
<summary>Statusline not showing</summary>

1. **Check script is executable:**

   ```bash
   ls -la ~/.claude/cc-litellm-statusline.sh
   ```

2. **Verify configuration:**

   ```bash
   cat ~/.claude/settings.json
   ```

   Should show:
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "/Users/yourusername/.claude/cc-litellm-statusline.sh"
     }
   }
   ```

   **Important:** Field must be `statusLine` (capital L) and include `type: "command"`

3. **Test script manually:**

   ```bash
   echo '{"workspace":{"current_dir":"'$(pwd)'"}}' | ~/.claude/cc-litellm-statusline.sh
   ```

4. **Reconfigure if needed:**

   If auto-configuration failed, manually edit `~/.claude/settings.json`:

   ```bash
   # Create or edit the file
   nano ~/.claude/settings.json

   # Add or update the statusLine configuration
   {
     "statusLine": {
       "type": "command",
       "command": "/Users/yourusername/.claude/cc-litellm-statusline.sh"
     }
   }
   ```

   **Important:**
   - Use the **absolute path** to the script, not `~/.claude/...`
   - Field must be `statusLine` (capital L) with `type: "command"`

</details>

<details>
<summary>Installation script failed to configure settings</summary>

If you see errors during auto-configuration:

1. **Check if jq is installed:**

   ```bash
   jq --version
   ```

2. **Manually configure settings.json:**

   ```bash
   # Ensure directory exists
   mkdir -p ~/.claude

   # Create/edit settings.json
   cat > ~/.claude/settings.json << 'EOF'
   {
     "statusLine": {
       "type": "command",
       "command": "/Users/yourusername/.claude/cc-litellm-statusline.sh"
     }
   }
   EOF
   ```

   Replace `/Users/yourusername` with your actual home directory path.

3. **Restore from backup if needed:**

   ```bash
   # If something went wrong, restore the backup
   cp ~/.claude/settings.json.backup ~/.claude/settings.json
   ```

</details>

<details>
<summary>Budget info not displaying</summary>

1. **Verify environment variables:**

   ```bash
   echo $LITELLM_BASE_URL  # Unix
   echo $LITELLM_API_KEY   # Unix

   $env:LITELLM_BASE_URL   # PowerShell
   $env:LITELLM_API_KEY    # PowerShell
   ```

   Both must be set for budget tracking to work.

2. **Test API connection:**

   ```bash
   curl -H "Authorization: Bearer $LITELLM_API_KEY" \
     "${LITELLM_BASE_URL}/key/info"
   ```

3. **Check network/firewall settings** - ensure your LiteLLM instance is accessible

</details>

<details>
<summary>Git info not showing</summary>

1. Ensure you're in a git repository:

   ```bash
   git status
   ```

2. Verify git is installed:

   ```bash
   git --version
   ```

</details>

<details>
<summary>Windows-specific issues</summary>

1. Use forward slashes in paths:

   ```
   /c/Users/username/.claude/cc-litellm-statusline.sh
   ```

2. Enable script execution (PowerShell):

   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. Ensure Git Bash or WSL is available

</details>

## 🎨 Customization Examples

### Minimal (No Budget)

Comment out lines 30-66 in the script to remove budget tracking.

### Different Git Icons

Replace line 25 in the script:

```bash
git_info=$(printf " \033[2;34;1m[%s]\033[0m" "$branch")
```

### Add Current Time

Add before the final printf (line 70):

```bash
time_info=$(date '+%H:%M')
```

Update final printf to include:

```bash
printf "... %s" "$dir_name" "$git_info" "$litellm_info" "$time_info"
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by [robbyrussell oh-my-zsh theme](https://github.com/ohmyzsh/ohmyzsh)
- Built for [Claude Code](https://claude.com/claude-code)
- Uses [LiteLLM](https://github.com/BerriAI/litellm) API

## 📊 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| macOS | ✅ Fully Supported | Intel & Apple Silicon |
| Linux | ✅ Fully Supported | Ubuntu, Debian, Fedora, Arch |
| Windows (WSL) | ✅ Fully Supported | Recommended for Windows |
| Windows (Git Bash) | ✅ Supported | Good compatibility |
| Windows (PowerShell) | ⚠️ Limited | Requires bash environment |

## 🔒 Security

- API keys stored in environment variables only
- HTTPS communication with LiteLLM API
- No sensitive data logged or cached
- Runs in user context only

## 📈 Performance

- **API calls**: 2-second timeout prevents hanging
- **Git operations**: Optimized with `--quiet` flags
- **Minimal overhead**: < 100ms execution time
- **Caching**: Results cached via timeout mechanism
