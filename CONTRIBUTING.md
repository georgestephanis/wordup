# Contributing to WordUp

Thank you for your interest in contributing to WordUp! This document provides guidelines for contributing to the project.

## Development Setup

### Prerequisites

- macOS 13.0 or later
- Xcode 14.0 or later
- Swift 5.9 or later

### Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/wordup.git
   cd wordup
   ```

3. Open the project in Xcode:
   ```bash
   open Package.swift
   ```

4. Build and run the project (⌘R)

## Project Structure

```
wordup/
├── Sources/
│   ├── main.swift              # App entry point
│   ├── AppDelegate.swift       # Main app delegate and menu bar setup
│   ├── MenuView.swift          # Menu bar popover UI
│   ├── AuthenticationView.swift # Authentication UI
│   ├── WordPressAuth.swift     # Authentication logic and Keychain management
│   └── WordPressAPI.swift      # WordPress REST API client
├── Package.swift               # Swift Package Manager configuration
├── README.md                   # Main documentation
└── build.sh                    # Build script
```

## Code Style

- Follow Swift naming conventions
- Use clear, descriptive variable names
- Add comments for complex logic
- Keep functions focused and single-purpose
- Use SwiftUI for UI components
- Follow the existing code structure

## Making Changes

1. Create a new branch for your feature or fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes
3. Test thoroughly on macOS
4. Commit with a clear message:
   ```bash
   git commit -m "Add feature: description"
   ```

5. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

6. Create a Pull Request

## Testing

Since this is a macOS menu bar app:

1. Test authentication with various WordPress sites
2. Test file uploads with different file types and sizes
3. Verify clipboard functionality
4. Check notifications work correctly
5. Test error handling (invalid credentials, network issues, etc.)

## Pull Request Guidelines

- Provide a clear description of the changes
- Reference any related issues
- Include screenshots for UI changes
- Ensure the code builds without warnings
- Test on macOS before submitting

## Reporting Issues

When reporting issues, please include:

- macOS version
- WordUp version
- WordPress version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Focus on what's best for the project

## Questions?

Feel free to open an issue for questions or discussions about the project.

Thank you for contributing! 🎉
