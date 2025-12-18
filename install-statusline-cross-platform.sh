#!/bin/bash
# Cross-platform installation script for LiteLLM statusline
# Supports: macOS, Linux, Windows (WSL/Git Bash)
# Usage: curl -fsSL <URL> | bash
# Or: bash install-statusline-cross-platform.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            OS="macos"
            ;;
        Linux*)
            OS="linux"
            # Check if running in WSL
            if grep -qi microsoft /proc/version 2>/dev/null; then
                OS="wsl"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            OS="windows"
            ;;
        *)
            OS="unknown"
            ;;
    esac
    echo "$OS"
}

# Detect package manager
detect_package_manager() {
    if command -v brew >/dev/null 2>&1; then
        echo "brew"
    elif command -v apt-get >/dev/null 2>&1; then
        echo "apt"
    elif command -v yum >/dev/null 2>&1; then
        echo "yum"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    else
        echo "none"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install dependencies based on package manager
install_dependencies() {
    local pkg_manager=$1
    local missing_deps=()

    # Check for required dependencies
    command_exists jq || missing_deps+=("jq")
    command_exists bc || missing_deps+=("bc")
    command_exists curl || missing_deps+=("curl")
    command_exists git || missing_deps+=("git")

    if [ ${#missing_deps[@]} -eq 0 ]; then
        echo -e "${GREEN}✅ All dependencies already installed${NC}"
        return 0
    fi

    echo -e "${YELLOW}📦 Installing missing dependencies: ${missing_deps[*]}${NC}"

    case "$pkg_manager" in
        brew)
            brew install "${missing_deps[@]}"
            ;;
        apt)
            sudo apt-get update
            sudo apt-get install -y "${missing_deps[@]}"
            ;;
        yum|dnf)
            sudo "$pkg_manager" install -y "${missing_deps[@]}"
            ;;
        pacman)
            sudo pacman -S --noconfirm "${missing_deps[@]}"
            ;;
        none)
            echo -e "${RED}❌ No package manager detected. Please install manually: ${missing_deps[*]}${NC}"
            echo ""
            echo "Visit:"
            echo "  - jq: https://stedolan.github.io/jq/download/"
            echo "  - bc: Usually pre-installed or available via your package manager"
            echo "  - curl: https://curl.se/download.html"
            echo "  - git: https://git-scm.com/downloads"
            return 1
            ;;
    esac
}

# Get Claude directory based on OS
get_claude_dir() {
    local os=$1
    case "$os" in
        macos|linux|wsl)
            echo "$HOME/.claude"
            ;;
        windows)
            # Git Bash/MSYS uses Unix-style paths
            echo "$HOME/.claude"
            ;;
        *)
            echo "$HOME/.claude"
            ;;
    esac
}

# Configure Claude Code settings.json
configure_claude_settings() {
    local script_path=$1
    local claude_dir=$2
    local settings_file="${claude_dir}/settings.json"

    echo -e "${BLUE}🔧 Configuring Claude Code settings...${NC}"

    # Check if settings file exists
    if [ -f "$settings_file" ]; then
        # Settings file exists, update it
        echo -e "${YELLOW}   Found existing settings.json${NC}"

        # Backup existing settings
        cp "$settings_file" "${settings_file}.backup"
        echo -e "${YELLOW}   Created backup: settings.json.backup${NC}"

        # Check if statusLine config already exists (note: capital L)
        if jq -e '.statusLine' "$settings_file" >/dev/null 2>&1; then
            # Update existing statusLine config
            jq --arg cmd "$script_path" '.statusLine.command = $cmd | .statusLine.type = "command"' "$settings_file" > "${settings_file}.tmp" && mv "${settings_file}.tmp" "$settings_file"
            echo -e "${GREEN}   ✅ Updated statusLine configuration${NC}"
        else
            # Add new statusLine config
            jq --arg cmd "$script_path" '. + {statusLine: {type: "command", command: $cmd}}' "$settings_file" > "${settings_file}.tmp" && mv "${settings_file}.tmp" "$settings_file"
            echo -e "${GREEN}   ✅ Added statusLine configuration${NC}"
        fi
    else
        # Create new settings file
        echo -e "${YELLOW}   Creating new settings.json${NC}"
        cat > "$settings_file" << EOF
{
  "statusLine": {
    "type": "command",
    "command": "$script_path"
  }
}
EOF
        echo -e "${GREEN}   ✅ Created settings.json with statusLine configuration${NC}"
    fi

    echo ""
}

# Main installation
main() {
    echo -e "${BLUE}🚀 LiteLLM Statusline Cross-Platform Installer${NC}"
    echo ""

    # Detect OS
    OS=$(detect_os)
    echo -e "${BLUE}🖥️  Detected OS: ${GREEN}$OS${NC}"

    # Detect package manager
    PKG_MANAGER=$(detect_package_manager)
    if [ "$PKG_MANAGER" != "none" ]; then
        echo -e "${BLUE}📦 Package manager: ${GREEN}$PKG_MANAGER${NC}"
    fi
    echo ""

    # Install dependencies
    if ! install_dependencies "$PKG_MANAGER"; then
        echo -e "${RED}❌ Failed to install dependencies${NC}"
        exit 1
    fi
    echo ""

    # Get Claude directory
    CLAUDE_DIR=$(get_claude_dir "$OS")
    SCRIPT_NAME="cc-litellm-statusline.sh"
    SCRIPT_PATH="${CLAUDE_DIR}/${SCRIPT_NAME}"

    # Create .claude directory if it doesn't exist
    mkdir -p "$CLAUDE_DIR"

    # Create the statusline script
    echo -e "${BLUE}📝 Creating statusline script...${NC}"
    cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash

# Read JSON input
input=$(cat)

# Extract current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Get just the directory name (like %c in zsh)
dir_name=$(basename "$cwd")

# Check if we're in a git repo and get branch info
git_info=""
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    # Get branch name
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        # Check if repo is dirty (skip optional locks with -c flag)
        if git -C "$cwd" -c core.useBuiltinFSMonitor=false diff --quiet 2>/dev/null && \
           git -C "$cwd" -c core.useBuiltinFSMonitor=false diff --cached --quiet 2>/dev/null; then
            # Clean repo - using printf for ANSI codes with dimmed colors
            git_info=$(printf " \033[2;34;1mgit:(\033[2;31m%s\033[2;34;1m)" "$branch")
        else
            # Dirty repo
            git_info=$(printf " \033[2;34;1mgit:(\033[2;31m%s\033[2;34;1m) \033[2;33;1m✗" "$branch")
        fi
    fi
fi

# Fetch LiteLLM budget info
litellm_info=""
if [ -n "$LITELLM_API_KEY" ] && [ -n "$LITELLM_BASE_URL" ]; then
    # Fetch data from LiteLLM API (with timeout to prevent hanging)
    RESPONSE=$(curl -s --max-time 2 -X 'GET' \
      "${LITELLM_BASE_URL}/key/info" \
      -H 'accept: application/json' \
      -H "Authorization: Bearer $LITELLM_API_KEY" 2>/dev/null)

    # Only process if we got valid JSON
    if echo "$RESPONSE" | jq -e . >/dev/null 2>&1; then
        MAX_BUDGET=$(echo "$RESPONSE" | jq -r '.info.max_budget // "null"')
        CURRENT_SPEND=$(echo "$RESPONSE" | jq -r '.info.spend // 0')

        if [ "$MAX_BUDGET" == "null" ] || [ "$MAX_BUDGET" == "0" ]; then
            # Unlimited budget
            litellm_info=$(printf " \033[2;35m💰\$%.2f/∞\033[0m" "$CURRENT_SPEND")
        else
            # Calculate percentage
            percent=$(echo "scale=0; ($CURRENT_SPEND * 100) / $MAX_BUDGET" | bc 2>/dev/null)
            if [ -z "$percent" ]; then percent=0; fi

            # Determine color based on percentage (dimmed versions)
            if [ $percent -gt 90 ]; then
                color="\033[2;31m"  # Dimmed red
            elif [ $percent -gt 75 ]; then
                color="\033[2;33m"  # Dimmed yellow
            else
                color="\033[2;32m"  # Dimmed green
            fi

            litellm_info=$(printf " ${color}💰\$%.2f/\$%.2f (%d%%)\033[0m" "$CURRENT_SPEND" "$MAX_BUDGET" "$percent")
        fi
    fi
fi

# Build the prompt with dimmed colors
printf "\033[2;32;1m➜\033[0m \033[2;36m%s\033[0m%s%s\033[0m" "$dir_name" "$git_info" "$litellm_info"
EOF

    # Make the script executable
    chmod +x "$SCRIPT_PATH"
    echo -e "${GREEN}✅ Script installed to: $SCRIPT_PATH${NC}"
    echo ""

    # Auto-configure Claude Code settings
    configure_claude_settings "$SCRIPT_PATH" "$CLAUDE_DIR"

    # Platform-specific environment variable instructions
    echo -e "${BLUE}📝 Final Configuration Steps:${NC}"
    echo ""
    echo "1️⃣  Set your LITELLM_BASE_URL environment variable:"
    echo ""

    case "$OS" in
        macos|linux)
            echo -e "   Add to ~/.bashrc or ~/.zshrc:"
            echo -e "   ${YELLOW}export LITELLM_BASE_URL='https://your-litellm-instance.com'${NC}"
            echo -e "   ${YELLOW}export LITELLM_API_KEY='your-api-key-here'${NC}"
            echo ""
            echo -e "   Then reload your shell:"
            echo -e "   ${YELLOW}source ~/.zshrc${NC}  # or source ~/.bashrc"
            ;;
        wsl)
            echo -e "   Add to ~/.bashrc:"
            echo -e "   ${YELLOW}export LITELLM_BASE_URL='https://your-litellm-instance.com'${NC}"
            echo -e "   ${YELLOW}export LITELLM_API_KEY='your-api-key-here'${NC}"
            echo ""
            echo -e "   Then reload your shell:"
            echo -e "   ${YELLOW}source ~/.bashrc${NC}"
            ;;
        windows)
            echo -e "   For Git Bash, add to ~/.bashrc:"
            echo -e "   ${YELLOW}export LITELLM_BASE_URL='https://your-litellm-instance.com'${NC}"
            echo -e "   ${YELLOW}export LITELLM_API_KEY='your-api-key-here'${NC}"
            echo ""
            echo -e "   For PowerShell, run:"
            echo -e "   ${YELLOW}[Environment]::SetEnvironmentVariable('LITELLM_BASE_URL', 'https://your-litellm-instance.com', 'User')${NC}"
            echo -e "   ${YELLOW}[Environment]::SetEnvironmentVariable('LITELLM_API_KEY', 'your-key', 'User')${NC}"
            ;;
    esac

    echo ""
    echo -e "${GREEN}🎉 Installation complete!${NC}"
    echo ""
    echo "Restart Claude Code to see your new statusline with:"
    echo "  • 📁 Current directory"
    echo "  • 🌿 Git branch & status"
    echo "  • 💰 LiteLLM budget tracking"
}

# Run main function
main
