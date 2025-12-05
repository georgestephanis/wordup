# WordUp Usage Guide

This guide walks you through using WordUp to upload files to your WordPress site.

## Initial Setup

### 1. First Launch

When you first launch WordUp, you'll see:
- A menu bar icon (upload arrow) in your macOS menu bar
- An authentication window prompting you to connect to your WordPress site

### 2. Generate Application Password

Before you can authenticate, you need to create an Application Password in WordPress:

1. Log in to your WordPress admin dashboard
2. Navigate to **Users → Profile** (or Users → Your Profile)
3. Scroll down to the **Application Passwords** section
4. In the "New Application Password Name" field, enter: `WordUp` (or any name you prefer)
5. Click **Add New Application Password**
6. WordPress will generate a password like: `xxxx xxxx xxxx xxxx xxxx xxxx`
7. **Important:** Copy this password immediately - you won't be able to see it again!

### 3. Connect to WordPress

In the WordUp authentication window:

1. **Site URL**: Enter your WordPress site URL
   - Example: `https://yoursite.com`
   - Include the protocol (https:// or http://)
   
2. **Username**: Enter your WordPress username
   
3. **Application Password**: Paste the Application Password you generated
   - Include all the spaces
   - Example: `1234 5678 90ab cdef ghij klmn`

4. Click **Connect**

WordUp will test the connection and save your credentials securely in the macOS Keychain.

## Uploading Files

### Method 1: Drag and Drop

1. Find a file you want to upload (image, document, etc.)
2. Drag it to the WordUp icon in your menu bar
3. Release the file over the icon
4. WordUp will upload the file to your WordPress media library
5. When complete, the media page URL is automatically copied to your clipboard
6. You'll see a notification confirming the upload

### Method 2: Using the Menu

Click the WordUp menu bar icon to:
- Check your authentication status
- See which site you're connected to
- Sign out
- Quit the application

## Common Tasks

### Changing Sites

To connect to a different WordPress site:
1. Click the WordUp menu bar icon
2. Click **Sign Out**
3. The authentication window will appear
4. Enter credentials for your new site

### Troubleshooting Upload Errors

If an upload fails, check:
- Your internet connection
- WordPress site is accessible
- File size is within WordPress limits
- Your user account has upload permissions
- Application Password is still valid

### Using Uploaded URLs

After a successful upload, the media page URL is in your clipboard. You can:
- Paste it into a document (⌘V)
- Use it in your WordPress posts/pages
- Share it with others

The URL will look like:
```
https://yoursite.com/media-filename/
```

## Tips and Tricks

### Quick Uploads
- Keep WordUp running in your menu bar for instant access
- Upload screenshots immediately after taking them
- Drag multiple files at once (they'll be uploaded sequentially)

### Organization
- WordPress automatically organizes uploads by date
- Files are uploaded to `/wp-content/uploads/YYYY/MM/`
- Use WordPress media library to organize and tag files

### Security
- Application Passwords can be revoked anytime from your WordPress profile
- WordUp stores credentials in macOS Keychain (encrypted)
- Each Application Password is specific to the device/app

## Keyboard Shortcuts

In the authentication window:
- **⌘W**: Close window
- **Return**: Connect (when all fields are filled)

## Privacy

WordUp:
- ✅ Stores credentials locally in macOS Keychain
- ✅ Communicates directly with your WordPress site
- ✅ No third-party servers involved
- ✅ No analytics or tracking
- ✅ No data collection

## WordPress Compatibility

WordUp requires:
- WordPress 5.6 or later (when Application Passwords were introduced)
- Self-hosted WordPress site (not WordPress.com free plan)
- REST API enabled (default for most installations)
- HTTPS recommended (but not required)

## Need Help?

If you encounter issues:
1. Check the error message in the notification
2. Verify your WordPress credentials
3. Ensure your WordPress site is accessible
4. Check WordPress REST API is enabled
5. Review the logs in Console.app (filter for "WordUp")

For additional support, visit: https://github.com/georgestephanis/wordup/issues
