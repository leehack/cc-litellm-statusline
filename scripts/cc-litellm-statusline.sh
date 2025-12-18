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
    # Using /key/info endpoint for API key-specific usage instead of global user usage
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
            # Green <75%, Yellow 75-90%, Red >90%
            if [ "$percent" -gt 90 ]; then
                color="\033[2;31m"  # Dimmed red
            elif [ "$percent" -gt 75 ]; then
                color="\033[2;33m"  # Dimmed yellow
            else
                color="\033[2;32m"  # Dimmed green
            fi

            litellm_info=$(printf " ${color}💰\$%.2f/\$%.2f (%d%%)\033[0m" "$CURRENT_SPEND" "$MAX_BUDGET" "$percent")
        fi
    fi
fi

# Build the prompt with dimmed colors (always green arrow for status line)
# Using dimmed versions of the robbyrussell theme colors
printf "\033[2;32;1m➜\033[0m \033[2;36m%s\033[0m%s%s\033[0m" "$dir_name" "$git_info" "$litellm_info"
