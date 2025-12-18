# Contributing to LiteLLM Statusline

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Assume good intentions

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](../../issues)
2. If not, create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - Your environment (OS, shell, Claude Code version)
   - Relevant logs or screenshots

### Suggesting Features

1. Check [Issues](../../issues) for existing feature requests
2. Create a new issue with:
   - Clear description of the feature
   - Use case and benefits
   - Possible implementation approach
   - Any potential drawbacks

### Pull Requests

1. **Fork the repository**

   ```bash
   git clone https://github.com/leehack/cc-litellm-statusline.git
   cd cc-litellm-statusline
   ```

2. **Create a feature branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Test on multiple platforms if possible
   - Update documentation as needed

4. **Test your changes**

   ```bash
   # Test the statusline script
   echo '{"workspace":{"current_dir":"'$(pwd)'"}}' | ./scripts/cc-litellm-statusline.sh

   # Test the installer
   bash install-statusline-cross-platform.sh
   ```

5. **Commit your changes**

   ```bash
   git add .
   git commit -m "Add: Brief description of your changes"
   ```

   **Commit message format:**
   - `Add:` for new features
   - `Fix:` for bug fixes
   - `Update:` for updates to existing features
   - `Docs:` for documentation changes
   - `Refactor:` for code refactoring
   - `Test:` for test additions/changes

6. **Push to your fork**

   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your branch
   - Fill in the PR template
   - Wait for review

## Development Guidelines

### Code Style

**Shell Scripts:**

- Use `#!/bin/bash` shebang
- 2-space indentation
- Use `[[` for tests instead of `[`
- Quote variables: `"$variable"`
- Use meaningful variable names
- Add comments for complex logic

**PowerShell:**

- Use approved verbs (Get-, Set-, New-, etc.)
- CamelCase for functions
- Add comment-based help
- Handle errors with try/catch

### Testing

Before submitting:

1. **Test on your platform**

   ```bash
   # Run the statusline
   echo '{"workspace":{"current_dir":"'$(pwd)'"}}' | ./scripts/cc-litellm-statusline.sh
   ```

2. **Test without API key**

   ```bash
   unset LITELLM_API_KEY
   echo '{"workspace":{"current_dir":"'$(pwd)'"}}' | ./scripts/cc-litellm-statusline.sh
   ```

3. **Test in non-git directory**

   ```bash
   cd /tmp
   echo '{"workspace":{"current_dir":"'$(pwd)'"}}' | /path/to/cc-litellm-statusline.sh
   ```

4. **Test installer**

   ```bash
   bash install-statusline-cross-platform.sh
   ```

### Platform Testing

If possible, test on:

- macOS (latest)
- Linux (Ubuntu/Debian preferred)
- Windows (WSL, Git Bash, or PowerShell)

If you can't test on all platforms, mention this in your PR.

## Project Structure

```
cc-litellm-statusline/
├── scripts/
│   └── cc-litellm-statusline.sh       # Main statusline script
├── install-statusline-cross-platform.sh  # Unix installer
├── install-statusline.ps1          # Windows PowerShell installer
├── README.md                       # Main documentation
├── CONTRIBUTING.md                 # This file
├── CHANGELOG.md                    # Version history
├── LICENSE                         # MIT license
└── .gitignore                      # Git ignore rules
```

## Areas for Contribution

### High Priority

- Testing on different platforms
- Documentation improvements
- Bug fixes
- Performance optimizations

### Medium Priority

- Additional LiteLLM provider support
- Custom color schemes
- Additional status indicators
- Configuration options

### Nice to Have

- Automated testing framework
- CI/CD pipeline
- Alternative theme options
- Plugin system

## Getting Help

- Open an issue for questions
- Check existing issues and PRs
- Read the README thoroughly
- Test locally before asking

## Recognition

Contributors will be:

- Listed in release notes
- Mentioned in README (for significant contributions)
- Appreciated in commit messages

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Feel free to open an issue with the label `question` if you need help or clarification.

Thank you for contributing! 🎉
