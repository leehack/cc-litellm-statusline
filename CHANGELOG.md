# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-18

### Added
- Initial release
- Cross-platform support (macOS, Linux, Windows)
- Git branch and status integration
- LiteLLM budget tracking with color-coded warnings
- Automatic dependency installation
- One-liner installation scripts for all platforms
- Bash installer for Unix-like systems
- PowerShell installer for Windows
- Comprehensive documentation
- Color-coded budget warnings (green, yellow, red)
- Dimmed color scheme for non-intrusive display
- Clean/dirty repository status indicator

### Features
- Current directory name display
- Git integration with branch detection
- API-based budget tracking
- 2-second timeout for API calls
- Automatic path conversion for Windows
- Support for unlimited budget display
- Percentage-based budget calculation
- Responsive design with fallback for missing data

### Platform Support
- macOS (Intel & Apple Silicon)
- Linux (Ubuntu, Debian, Fedora, Arch)
- Windows (WSL, Git Bash, PowerShell)

### Security
- Environment variable-based API key storage
- HTTPS-only API communication
- No sensitive data caching
- User-context execution only
