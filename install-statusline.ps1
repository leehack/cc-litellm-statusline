# PowerShell installation script for LiteLLM statusline (Windows)
# Usage: iwr -useb <URL> | iex
# Or: powershell -ExecutionPolicy Bypass -File install-statusline.ps1

$ErrorActionPreference = "Stop"

# Colors
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Check if running as Administrator (for dependency installation)
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check if command exists
function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Install dependencies
function Install-Dependencies {
    Write-ColorOutput "`n📦 Checking dependencies..." "Cyan"

    $missingDeps = @()

    if (-not (Test-CommandExists "jq")) { $missingDeps += "jq" }
    if (-not (Test-CommandExists "curl")) { $missingDeps += "curl" }
    if (-not (Test-CommandExists "git")) { $missingDeps += "git" }

    if ($missingDeps.Count -eq 0) {
        Write-ColorOutput "✅ All dependencies already installed" "Green"
        return $true
    }

    Write-ColorOutput "Missing dependencies: $($missingDeps -join ', ')" "Yellow"

    # Check for package managers
    $hasChoco = Test-CommandExists "choco"
    $hasScoop = Test-CommandExists "scoop"
    $hasWinget = Test-CommandExists "winget"

    if ($hasChoco) {
        Write-ColorOutput "Installing via Chocolatey..." "Cyan"
        foreach ($dep in $missingDeps) {
            choco install $dep -y
        }
    }
    elseif ($hasScoop) {
        Write-ColorOutput "Installing via Scoop..." "Cyan"
        foreach ($dep in $missingDeps) {
            scoop install $dep
        }
    }
    elseif ($hasWinget) {
        Write-ColorOutput "Installing via Winget..." "Cyan"
        $depMap = @{
            "jq" = "jqlang.jq"
            "curl" = "curl.curl"
            "git" = "Git.Git"
        }
        foreach ($dep in $missingDeps) {
            winget install --id $depMap[$dep] -e
        }
    }
    else {
        Write-ColorOutput "❌ No package manager found. Please install manually:" "Red"
        Write-ColorOutput "  - Chocolatey: https://chocolatey.org/install" "Yellow"
        Write-ColorOutput "  - Scoop: https://scoop.sh" "Yellow"
        Write-ColorOutput "  - Or install individually:" "Yellow"
        Write-ColorOutput "    • jq: https://stedolan.github.io/jq/download/" "Yellow"
        Write-ColorOutput "    • curl: https://curl.se/windows/" "Yellow"
        Write-ColorOutput "    • git: https://git-scm.com/downloads" "Yellow"
        return $false
    }

    return $true
}

# Main installation
function Main {
    Write-ColorOutput "`n🚀 LiteLLM Statusline Installer for Windows" "Blue"
    Write-ColorOutput "============================================`n" "Blue"

    # Install dependencies
    if (-not (Install-Dependencies)) {
        Write-ColorOutput "`n❌ Failed to install dependencies" "Red"
        exit 1
    }

    # Get Claude directory
    $claudeDir = Join-Path $env:USERPROFILE ".claude"
    $scriptPath = Join-Path $claudeDir "cc-litellm-statusline.sh"

    # Create directory if it doesn't exist
    if (-not (Test-Path $claudeDir)) {
        New-Item -ItemType Directory -Path $claudeDir | Out-Null
    }

    Write-ColorOutput "`n📝 Creating statusline script..." "Cyan"

    # Create the statusline script
    $scriptContent = @'
#!/bin/bash

# Read JSON input
input=$(cat)

# Extract current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Convert Windows paths to Unix-style if needed
if [[ "$cwd" =~ ^[A-Za-z]: ]]; then
    # Convert C:\path to /c/path format
    cwd=$(echo "$cwd" | sed 's|^\([A-Za-z]\):|/\L\1|' | sed 's|\\|/|g')
fi

# Get just the directory name
dir_name=$(basename "$cwd")

# Check if we're in a git repo and get branch info
git_info=""
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        if git -C "$cwd" -c core.useBuiltinFSMonitor=false diff --quiet 2>/dev/null && \
           git -C "$cwd" -c core.useBuiltinFSMonitor=false diff --cached --quiet 2>/dev/null; then
            git_info=$(printf " \033[2;34;1mgit:(\033[2;31m%s\033[2;34;1m)" "$branch")
        else
            git_info=$(printf " \033[2;34;1mgit:(\033[2;31m%s\033[2;34;1m) \033[2;33;1m✗" "$branch")
        fi
    fi
fi

# Fetch LiteLLM budget info
litellm_info=""
if [ -n "$LITELLM_API_KEY" ]; then
    RESPONSE=$(curl -s --max-time 2 -X 'GET' \
      "https://uai-litellm.internal.unity.com/key/info" \
      -H 'accept: application/json' \
      -H "Authorization: Bearer $LITELLM_API_KEY" 2>/dev/null)

    if echo "$RESPONSE" | jq -e . >/dev/null 2>&1; then
        MAX_BUDGET=$(echo "$RESPONSE" | jq -r '.info.max_budget // "null"')
        CURRENT_SPEND=$(echo "$RESPONSE" | jq -r '.info.spend // 0')

        if [ "$MAX_BUDGET" == "null" ] || [ "$MAX_BUDGET" == "0" ]; then
            litellm_info=$(printf " \033[2;35m💰\$%.2f/∞\033[0m" "$CURRENT_SPEND")
        else
            percent=$(echo "scale=0; ($CURRENT_SPEND * 100) / $MAX_BUDGET" | bc 2>/dev/null)
            if [ -z "$percent" ]; then percent=0; fi

            if [ $percent -gt 90 ]; then
                color="\033[2;31m"
            elif [ $percent -gt 75 ]; then
                color="\033[2;33m"
            else
                color="\033[2;32m"
            fi

            litellm_info=$(printf " ${color}💰\$%.2f/\$%.2f (%d%%)\033[0m" "$CURRENT_SPEND" "$MAX_BUDGET" "$percent")
        fi
    fi
fi

printf "\033[2;32;1m➜\033[0m \033[2;36m%s\033[0m%s%s\033[0m" "$dir_name" "$git_info" "$litellm_info"
'@

    Set-Content -Path $scriptPath -Value $scriptContent -Encoding UTF8
    Write-ColorOutput "✅ Script installed to: $scriptPath" "Green"

    # Configuration instructions
    Write-ColorOutput "`n📝 Configuration Instructions:" "Blue"
    Write-ColorOutput "`n1️⃣  Set your LITELLM_API_KEY environment variable:" "White"
    Write-ColorOutput "`n   PowerShell (permanent):" "White"
    Write-ColorOutput "   [System.Environment]::SetEnvironmentVariable('LITELLM_API_KEY', 'your-key-here', 'User')" "Yellow"
    Write-ColorOutput "`n   Or for current session only:" "White"
    Write-ColorOutput "   `$env:LITELLM_API_KEY = 'your-key-here'" "Yellow"

    Write-ColorOutput "`n2️⃣  Configure Claude Code:" "White"

    # Convert path to Unix-style for Claude Code
    $unixPath = $scriptPath -replace '\\', '/' -replace '^([A-Z]):', { '/'+$_.Groups[1].Value.ToLower() }

    Write-ColorOutput "   claude-code config set statusline.command `"$unixPath`"" "Yellow"

    Write-ColorOutput "`n   Or manually edit $claudeDir\settings.json:" "White"
    Write-ColorOutput "   {`"statusline`": {`"command`": `"$unixPath`"}}" "Yellow"

    Write-ColorOutput "`n🎉 Installation complete!" "Green"
    Write-ColorOutput "`nRestart Claude Code to see your new statusline with:" "White"
    Write-ColorOutput "  • 📁 Current directory" "White"
    Write-ColorOutput "  • 🌿 Git branch & status" "White"
    Write-ColorOutput "  • 💰 LiteLLM budget tracking" "White"
    Write-ColorOutput "" "White"
}

# Run main function
Main
