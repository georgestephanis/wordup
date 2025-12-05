# WordUp - Quick Start Guide

A quick reference for getting WordUp up and running.

## For Users

### Install & Run

1. **Build the app** (requires macOS and Xcode):
   ```bash
   git clone https://github.com/georgestephanis/wordup.git
   cd wordup
   ./build.sh
   ```

2. **Run WordUp**:
   ```bash
   .build/release/WordUp
   ```
   Or double-click the binary in Finder.

### First-Time Setup

1. **In WordPress**:
   - Go to your profile (Users → Profile)
   - Scroll to "Application Passwords"
   - Enter name: "WordUp"
   - Click "Add New Application Password"
   - Copy the password (with spaces)

2. **In WordUp**:
   - Enter your site URL: `https://yoursite.com`
   - Enter your username
   - Paste the Application Password
   - Click "Connect"

3. **Upload Files**:
   - Drag any file to the WordUp icon in menu bar
   - Wait for "Upload Successful" notification
   - Paste (⌘V) to use the URL

## For Developers

### Project Structure

```
wordup/
├── Sources/
│   ├── main.swift              # App entry point
│   ├── AppDelegate.swift       # Menu bar setup, drag-drop
│   ├── MenuView.swift          # Menu popover UI
│   ├── AuthenticationView.swift # Auth UI
│   ├── WordPressAuth.swift     # Auth + Keychain
│   └── WordPressAPI.swift      # REST API client
├── Package.swift               # SPM configuration
├── build.sh                    # Build script
└── README.md                   # Full documentation
```

### Key Technologies

- **Language**: Swift 5.9+
- **UI**: SwiftUI + AppKit
- **Platform**: macOS 13.0+
- **Package Manager**: Swift PM
- **Authentication**: Keychain
- **API**: WordPress REST API v2

### Build Commands

```bash
# Debug build
swift build

# Release build
swift build -c release

# Run from source
swift run

# Open in Xcode
open Package.swift
```

### Architecture

1. **AppDelegate**: NSApplicationDelegate that manages:
   - Status bar item (NSStatusItem)
   - Popover menu
   - Drag-and-drop handling (DragDropView)
   - Authentication window lifecycle

2. **WordPressAuth**: Singleton that handles:
   - Connection testing
   - Credential storage (Keychain + UserDefaults)
   - Authentication state

3. **WordPressAPI**: Upload handler that:
   - Reads file data
   - Constructs multipart requests
   - Handles Basic auth headers
   - Returns media page URL

4. **Views**: SwiftUI views for:
   - MenuView: Status and controls
   - AuthenticationView: Login form

### Common Tasks

**Add a new menu item:**
```swift
// In MenuView.swift
Button(action: {
    // Your action
}) {
    Text("New Feature")
}
```

**Change upload behavior:**
```swift
// In WordPressAPI.swift
func uploadFile(_ fileURL: URL) async throws -> String {
    // Modify upload logic
}
```

**Add notification:**
```swift
// In AppDelegate.swift
appDelegate?.showNotification(
    title: "Title",
    message: "Message"
)
```

### Debugging

**View logs:**
```bash
# Open Console.app and filter for "WordUp"
```

**Check Keychain:**
```bash
# Open Keychain Access.app
# Search: "com.wordup.wordpress"
```

**Test authentication:**
```bash
# Test WordPress API manually
curl -u "username:app_password" \
  https://yoursite.com/wp-json/wp/v2/users/me
```

### Common Issues

**"No such module 'Cocoa'"**
- Building on Linux/Windows
- Solution: Must build on macOS

**Upload fails with 401**
- Invalid credentials
- Application Password revoked
- Solution: Re-authenticate

**Drag-drop doesn't work**
- Menu bar icon not accepting drops
- Solution: Check DragDropView registration

## Quick Reference

### WordPress REST API Endpoints

- **Test auth**: `/wp-json/wp/v2/users/me`
- **Upload**: `/wp-json/wp/v2/media`
- **Method**: POST with file data
- **Auth**: Basic (username:app_password)

### File Paths

- **Site URL**: UserDefaults
- **Username**: UserDefaults  
- **Password**: Keychain (encrypted)

### Constants

Menu sizes defined in each View's `Layout` enum:
- Menu: 300x200
- Auth window: 500x400

## Resources

- [WordPress REST API Handbook](https://developer.wordpress.org/rest-api/)
- [Application Passwords](https://make.wordpress.org/core/2020/11/05/application-passwords-integration-guide/)
- [Swift Package Manager](https://swift.org/package-manager/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)

## Getting Help

- Issues: https://github.com/georgestephanis/wordup/issues
- Documentation: README.md, USAGE.md, CONTRIBUTING.md
- Testing: TESTING.md

---

Happy coding! 🚀
