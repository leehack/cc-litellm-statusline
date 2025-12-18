#!/bin/bash
# Minimal version - no LiteLLM budget tracking

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
            git_info=$(printf " \033[2;34;1mgit:(\033[2;31m%s\033[2;34;1m)" "$branch")
        else
            git_info=$(printf " \033[2;34;1mgit:(\033[2;31m%s\033[2;34;1m) \033[2;33;1m✗" "$branch")
        fi
    fi
fi

# Build the prompt
printf "\033[2;32;1m➜\033[0m \033[2;36m%s\033[0m%s\033[0m" "$dir_name" "$git_info"
