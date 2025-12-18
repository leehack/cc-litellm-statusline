# Publishing to GitHub - Step by Step Guide

This guide will walk you through publishing this project to GitHub.

## Prerequisites

- Git installed
- GitHub account
- Git configured with your credentials

## Step 1: Update README URLs

Before publishing, update the placeholder URLs in these files:

**Files to update:**

- `README.md` - Lines with `leehack/cc-litellm-statusline`
- `QUICKSTART.md` - Installation URLs
- All example scripts if they reference the repo

**Find and replace:**

```bash
# From project root
cd ~/cc-litellm-statusline

# Replace leehack with your actual GitHub username
find . -type f -name "*.md" -exec sed -i '' 's/leehack/your-github-username/g' {} +
```

Or manually search and replace `leehack` with your GitHub username.

## Step 2: Update LICENSE

Edit `LICENSE` file and replace `[Your Name]` with your actual name:

```
Copyright (c) 2025 Your Name
```

## Step 3: Initialize Git Repository

```bash
cd ~/cc-litellm-statusline

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: LiteLLM Statusline for Claude Code

- Cross-platform support (macOS, Linux, Windows)
- Git integration with branch and status
- LiteLLM budget tracking with color-coded warnings
- Automatic dependency installation
- Comprehensive documentation and examples"
```

## Step 4: Create GitHub Repository

### Option A: Using GitHub CLI (gh)

```bash
# Install gh if needed
brew install gh  # macOS
# or visit https://cli.github.com/

# Login to GitHub
gh auth login

# Create repository
gh repo create cc-litellm-statusline \
  --public \
  --source=. \
  --description="Beautiful statusline for Claude Code with Git integration and LiteLLM budget tracking" \
  --push
```

### Option B: Using GitHub Web Interface

1. Go to <https://github.com/new>
2. Repository name: `cc-litellm-statusline`
3. Description: `Beautiful statusline for Claude Code with Git integration and LiteLLM budget tracking`
4. Choose **Public**
5. **Don't** initialize with README (we have our own)
6. Click "Create repository"

Then push your code:

```bash
# Add remote
git remote add origin https://github.com/leehack/cc-litellm-statusline.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 5: Configure Repository Settings

On GitHub, go to your repository settings:

### Topics/Tags

Add relevant topics:

- `claude-code`
- `statusline`
- `litellm`
- `shell-script`
- `cli`
- `git-integration`

### About Section

- Description: "Beautiful statusline for Claude Code with Git integration and LiteLLM budget tracking"
- Website: (optional - link to docs)
- Check ✅ "Releases"
- Check ✅ "Packages"

### Features

Enable these features:

- ✅ Issues
- ✅ Discussions (optional - for Q&A)
- ✅ Wiki (optional)

## Step 6: Create First Release

```bash
# Tag the release
git tag -a v1.0.0 -m "Release v1.0.0

Features:
- Cross-platform installation
- Git branch and status integration
- LiteLLM budget tracking
- Automatic dependency management
- Comprehensive documentation"

# Push the tag
git push origin v1.0.0
```

Then on GitHub:

1. Go to "Releases"
2. Click "Draft a new release"
3. Choose tag `v1.0.0`
4. Release title: `v1.0.0 - Initial Release`
5. Copy content from `CHANGELOG.md`
6. Click "Publish release"

## Step 7: Test Installation

Test your one-liner installation:

```bash
# Test the URL works
curl -fsSL https://raw.githubusercontent.com/leehack/cc-litellm-statusline/main/install-statusline-cross-platform.sh

# Test full installation in a fresh environment
curl -fsSL https://raw.githubusercontent.com/leehack/cc-litellm-statusline/main/install-statusline-cross-platform.sh | bash
```

## Step 8: Update Documentation (Final)

After confirming the installation URLs work, update any remaining documentation:

1. Take a screenshot of the statusline in action
2. Add screenshot to README (upload to GitHub issues first to get URL)
3. Commit and push changes

```bash
git add README.md
git commit -m "Docs: Add screenshot and verified installation URLs"
git push
```

## Step 9: Share Your Project

### Add Badges to README

Add these at the top of your README.md:

```markdown
![GitHub release](https://img.shields.io/github/v/release/leehack/cc-litellm-statusline)
![GitHub stars](https://img.shields.io/github/stars/leehack/cc-litellm-statusline)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey)
![License](https://img.shields.io/badge/license-MIT-blue)
```

### Share on Social Media

- Reddit: r/claudecode, r/commandline
- Hacker News
- Twitter/X
- LinkedIn

### Submit to Package Managers (Optional)

Consider submitting to:

- Homebrew tap (macOS)
- AUR (Arch Linux)
- Scoop bucket (Windows)

## Maintenance

### Regular Updates

```bash
# Make changes
git add .
git commit -m "Fix: Description of fix"
git push

# For releases
git tag -a v1.0.1 -m "Release notes"
git push origin v1.0.1
```

### Responding to Issues

- Enable email notifications for issues
- Respond within 24-48 hours
- Use issue labels: `bug`, `enhancement`, `question`, `help wanted`
- Close issues when resolved

### Security

- Enable Dependabot alerts
- Review pull requests carefully
- Never commit API keys or secrets
- Use GitHub security advisories for vulnerabilities

## Next Steps

Consider adding:

- [ ] Screenshot/demo GIF
- [ ] Video tutorial
- [ ] Homebrew formula
- [ ] Integration with other tools
- [ ] Plugin system
- [ ] Contribution from community

## Checklist

Before going public, verify:

- [ ] All `leehack` replaced with actual username
- [ ] LICENSE has your name
- [ ] Installation URLs work
- [ ] README is clear and complete
- [ ] Examples are tested
- [ ] GitHub Actions pass
- [ ] Repository settings configured
- [ ] First release created
- [ ] Installation tested from GitHub

## Questions?

If you need help with publishing:

1. Check [GitHub's documentation](https://docs.github.com/)
2. Visit [GitHub Community](https://github.community/)
3. Ask in relevant subreddits

Good luck with your project! 🚀
