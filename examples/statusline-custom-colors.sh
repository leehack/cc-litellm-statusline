#!/bin/bash
# Custom color scheme - bright colors instead of dimmed

# Read JSON input
input=$(cat)

# Extract current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Get just the directory name
dir_name=$(basename "$cwd")

# Check if we're in a git repo and get branch info
git_info=""
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        if git -C "$cwd" diff --quiet 2>/dev/null && \
           git -C "$cwd" diff --cached --quiet 2>/dev/null; then
            # Clean repo - bright colors (no dim)
            git_info=$(printf " \033[34;1mgit:(\033[31m%s\033[34;1m)" "$branch")
        else
            # Dirty repo - bright colors
            git_info=$(printf " \033[34;1mgit:(\033[31m%s\033[34;1m) \033[33;1m✗" "$branch")
        fi
    fi
fi

# Fetch LiteLLM budget info with bright colors
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
            # Unlimited budget - bright magenta
            litellm_info=$(printf " \033[35m💰\$%.2f/∞\033[0m" "$CURRENT_SPEND")
        else
            percent=$(echo "scale=0; ($CURRENT_SPEND * 100) / $MAX_BUDGET" | bc 2>/dev/null)
            if [ -z "$percent" ]; then percent=0; fi

            # Bright colors instead of dimmed
            if [ $percent -gt 90 ]; then
                color="\033[31;1m"  # Bright red
            elif [ $percent -gt 75 ]; then
                color="\033[33;1m"  # Bright yellow
            else
                color="\033[32;1m"  # Bright green
            fi

            litellm_info=$(printf " ${color}💰\$%.2f/\$%.2f (%d%%)\033[0m" "$CURRENT_SPEND" "$MAX_BUDGET" "$percent")
        fi
    fi
fi

# Build the prompt with bright colors
printf "\033[32;1m➜\033[0m \033[36;1m%s\033[0m%s%s\033[0m" "$dir_name" "$git_info" "$litellm_info"
