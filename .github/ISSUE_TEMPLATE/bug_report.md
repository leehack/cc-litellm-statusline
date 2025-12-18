---
name: Bug report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''
---

## Bug Description
A clear and concise description of what the bug is.

## Environment
- **OS**: [e.g., macOS 14.0, Ubuntu 22.04, Windows 11]
- **Shell**: [e.g., bash, zsh, PowerShell, Git Bash]
- **Claude Code Version**: [e.g., 1.0.0]
- **Installation Method**: [one-liner, manual, local]

## Steps to Reproduce
1. Go to '...'
2. Run command '...'
3. See error

## Expected Behavior
A clear description of what you expected to happen.

## Actual Behavior
What actually happened.

## Screenshots/Logs
If applicable, add screenshots or logs to help explain your problem.

```
Paste relevant logs here
```

## Additional Context
- Have you set `LITELLM_API_KEY`? [yes/no]
- Are you in a git repository? [yes/no]
- Does the script run manually? [yes/no]

```bash
# Test script manually
echo '{"workspace":{"current_dir":"'$(pwd)'"}}' | ~/.claude/cc-litellm-statusline.sh
```

## Checklist
- [ ] I have checked existing issues
- [ ] I have tested the script manually
- [ ] I have verified dependencies are installed
- [ ] I have included relevant logs/screenshots
