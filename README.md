# WordUp

A macOS menu bar app for quickly uploading screenshots and files to your self-hosted WordPress site's media library.

## Features

- 🔐 **Secure Authentication**: Uses WordPress Application Passwords for secure access
- 📤 **Drag & Drop Upload**: Simply drag files to the menu bar icon to upload
- 📋 **Auto Clipboard**: Automatically copies the WordPress media page URL to your clipboard
- 🔔 **Native Notifications**: Get notified when uploads complete or fail
- 🔑 **Keychain Storage**: Securely stores your credentials in the macOS Keychain

## Requirements

- macOS 13.0 or later
- A self-hosted WordPress site with Application Passwords enabled (WordPress 5.6+)

## Building from Source

This app is built using Swift and Swift Package Manager.

### Prerequisites

- Xcode 14.0 or later
- macOS 13.0 or later

### Build Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/georgestephanis/wordup.git
   cd wordup
   ```

2. Open the project in Xcode:
   ```bash
   open Package.swift
   ```

3. **Important**: Configure the Info.plist in Xcode:
   - In Xcode, select the WordUp target
   - Go to the "Build Settings" tab
   - Search for "Info.plist File"
   - Set the value to `Info.plist` (the file in the root directory)
   
   This step is necessary to ensure the app bundle is properly configured, which is required for features like notifications to work correctly.

4. Build and run the project in Xcode (⌘R)

Alternatively, you can build from the command line:

```bash
swift build -c release
```

The compiled binary will be located at `.build/release/WordUp`.

**Note**: When building with Xcode, the Info.plist configuration is essential. Without it, you may encounter errors related to `bundleProxyForCurrentProcess` when using UserNotifications or other system frameworks that require a proper app bundle.

## Usage

### First Time Setup

1. Launch WordUp - it will appear in your menu bar with an upload icon
2. On first launch, you'll be prompted to authenticate
3. Enter your WordPress site details:
   - **Site URL**: Your WordPress site URL (e.g., `https://yoursite.com`)
   - **Username**: Your WordPress username
   - **Application Password**: Generate one from your WordPress profile

### Generating an Application Password

1. Log in to your WordPress admin dashboard
2. Go to **Users → Profile**
3. Scroll down to the **Application Passwords** section
4. Enter a name for the application (e.g., "WordUp")
5. Click **Add New Application Password**
6. Copy the generated password (including spaces) and paste it into WordUp

### Uploading Files

1. Drag and drop any file onto the WordUp menu bar icon
2. The file will be uploaded to your WordPress media library
3. Once complete, the media page URL will be copied to your clipboard
4. You'll receive a notification confirming the upload

### Menu Options

Click the WordUp menu bar icon to access:
- **Authentication Status**: See if you're connected
- **Sign Out**: Disconnect from your WordPress site
- **Quit**: Exit the application

## Security

- Credentials are stored securely in the macOS Keychain
- Uses WordPress Application Passwords (not your actual password)
- All communication is done over HTTPS
- No third-party services or analytics

## Supported File Types

WordUp supports uploading any file type that WordPress accepts, including:
- Images (JPEG, PNG, GIF, WebP, etc.)
- Documents (PDF, DOC, DOCX, etc.)
- Audio files (MP3, WAV, etc.)
- Video files (MP4, MOV, etc.)

## Troubleshooting

### Authentication fails
- Ensure your WordPress site has Application Passwords enabled
- Check that you're using WordPress 5.6 or later
- Verify your site URL includes the protocol (https://)
- Make sure you copied the entire Application Password including spaces

### Upload fails
- Check your WordPress site's upload file size limits
- Ensure your WordPress user has permission to upload media
- Verify your internet connection

## License

This project is licensed under the GNU General Public License v2.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
