# Examples

This directory contains example configurations and customizations for the LiteLLM statusline.

## Files

### Configuration

- **`settings.json`** - Example Claude Code settings file

### Statusline Variants

- **`statusline-minimal.sh`** - Minimal version without LiteLLM budget tracking
- **`statusline-custom-colors.sh`** - Bright color scheme instead of dimmed colors

## Using These Examples

### Minimal Statusline (No Budget Tracking)

If you don't need LiteLLM budget tracking:

```bash
cp examples/statusline-minimal.sh ~/.claude/cc-litellm-statusline.sh
chmod +x ~/.claude/cc-litellm-statusline.sh
```

### Custom Colors

For a brighter color scheme:

```bash
cp examples/statusline-custom-colors.sh ~/.claude/cc-litellm-statusline.sh
chmod +x ~/.claude/cc-litellm-statusline.sh
```

### Settings Configuration

Copy example settings:

```bash
cp examples/settings.json ~/.claude/settings.json
```

Then edit paths as needed.

## Creating Your Own Customization

### Color Codes Reference

ANSI color codes used in the scripts:

```bash
# Regular colors
\033[30m  # Black
\033[31m  # Red
\033[32m  # Green
\033[33m  # Yellow
\033[34m  # Blue
\033[35m  # Magenta
\033[36m  # Cyan
\033[37m  # White

# Bright colors
\033[91m  # Bright Red
\033[92m  # Bright Green
\033[93m  # Bright Yellow
\033[94m  # Bright Blue
\033[95m  # Bright Magenta
\033[96m  # Bright Cyan

# Dimmed colors (used in default)
\033[2;31m  # Dimmed Red
\033[2;32m  # Dimmed Green
\033[2;33m  # Dimmed Yellow
\033[2;34m  # Dimmed Blue

# Styles
\033[0m   # Reset
\033[1m   # Bold
\033[2m   # Dim
```

### Adding Custom Information

Example: Add current time

```bash
# Add before the final printf
time_info=$(date '+%H:%M')

# Update final printf to include time
printf "... %s %s" "$dir_name" "$git_info" "$time_info"
```

Example: Add Python virtual environment

```bash
# Add before git_info section
venv_info=""
if [ -n "$VIRTUAL_ENV" ]; then
    venv_name=$(basename "$VIRTUAL_ENV")
    venv_info=$(printf " \033[2;35m(venv:%s)\033[0m" "$venv_name")
fi

# Include in final printf
printf "... %s %s" "$dir_name" "$venv_info" "$git_info"
```

### Testing Your Customization

```bash
# Test manually
echo '{"workspace":{"current_dir":"'$(pwd)'"}}' | ~/.claude/cc-litellm-statusline.sh

# Test in git repo
cd /path/to/git/repo
echo '{"workspace":{"current_dir":"'$(pwd)'"}}' | ~/.claude/cc-litellm-statusline.sh

# Test with modified files
# (Make some changes first)
echo '{"workspace":{"current_dir":"'$(pwd)'"}}' | ~/.claude/cc-litellm-statusline.sh
```

## Share Your Customization

If you create a cool customization, consider:
1. Opening a PR to add it to this examples directory
2. Sharing it in a GitHub discussion
3. Creating a gist and linking it in an issue

## More Ideas

- Show Kubernetes context
- Display AWS profile
- Show Node.js version
- Display Docker container status
- Add custom emoji indicators
- Show last commit time
- Display test status

See the [Contributing Guide](../CONTRIBUTING.md) for how to share your customizations!
