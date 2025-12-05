# Testing Guide for WordUp

This document describes how to test WordUp functionality.

## Prerequisites

- macOS 13.0 or later
- A self-hosted WordPress site with:
  - WordPress 5.6 or later
  - Application Passwords enabled
  - REST API accessible
  - Your user account with upload permissions

## Manual Testing Checklist

### 1. Initial Setup and Authentication

**Test: First Launch**
- [ ] App appears in menu bar with upload icon
- [ ] Authentication window appears automatically
- [ ] Window is properly centered

**Test: Authentication UI**
- [ ] All three input fields are visible (Site URL, Username, Application Password)
- [ ] Help icon is clickable and shows/hides instructions
- [ ] Instructions are clear and accurate
- [ ] Cancel button closes window
- [ ] Connect button is disabled when fields are empty

**Test: Invalid Credentials**
- [ ] Enter invalid site URL → See "Invalid site URL" error
- [ ] Enter valid URL with invalid credentials → See "Invalid username or application password" error
- [ ] Enter unreachable site → See "Failed to connect to WordPress site" error

**Test: Successful Authentication**
- [ ] Enter valid credentials
- [ ] Click Connect
- [ ] Loading indicator appears
- [ ] Window closes on success
- [ ] Menu shows "✓ Authenticated" when clicked

### 2. File Upload

**Test: Drag and Drop - Images**
- [ ] Drag a JPEG image to menu bar icon
- [ ] See notification "Upload Successful"
- [ ] URL is in clipboard (test with ⌘V)
- [ ] URL points to WordPress media page

**Test: Drag and Drop - Documents**
- [ ] Drag a PDF file to menu bar icon
- [ ] Upload succeeds
- [ ] URL copied to clipboard

**Test: Drag and Drop - Multiple Files**
- [ ] Drag 2-3 files to menu bar icon
- [ ] All files upload sequentially
- [ ] Final URL in clipboard is from last file

**Test: Large Files**
- [ ] Try uploading a file larger than WordPress upload limit
- [ ] Verify appropriate error message

**Test: Invalid File Types**
- [ ] Try uploading a file type WordPress doesn't accept
- [ ] Verify error handling

### 3. Menu Functionality

**Test: Menu Display**
- [ ] Click menu bar icon
- [ ] Popover appears below icon
- [ ] Shows authentication status
- [ ] Shows site URL when authenticated

**Test: Sign Out**
- [ ] Click "Sign Out" button
- [ ] Menu updates to show "⚠ Not Authenticated"
- [ ] Authentication window appears
- [ ] Try uploading → Should fail or prompt for auth

**Test: Quit**
- [ ] Click "Quit" button
- [ ] App exits completely
- [ ] Icon disappears from menu bar

### 4. Notification System

**Test: Upload Success Notification**
- [ ] Upload a file
- [ ] Notification appears with title "Upload Successful"
- [ ] Message says "URL copied to clipboard"
- [ ] Sound plays (if system sounds enabled)

**Test: Upload Failure Notification**
- [ ] Trigger an upload failure (disconnect internet, etc.)
- [ ] Notification appears with title "Upload Failed"
- [ ] Error message is descriptive

### 5. Credential Persistence

**Test: Credentials Saved**
- [ ] Authenticate successfully
- [ ] Quit app
- [ ] Relaunch app
- [ ] App remembers authentication (no prompt)
- [ ] Can upload files immediately

**Test: Sign Out Clears Credentials**
- [ ] Sign out
- [ ] Quit app
- [ ] Relaunch app
- [ ] Authentication window appears (credentials forgotten)

### 6. Edge Cases

**Test: Network Issues**
- [ ] Disconnect from internet
- [ ] Try to authenticate → See connection error
- [ ] Try to upload → See upload error
- [ ] Reconnect internet
- [ ] Uploads work again

**Test: WordPress Site Issues**
- [ ] Temporarily disable WordPress REST API
- [ ] Try authentication → See connection error
- [ ] Re-enable API
- [ ] Authentication works

**Test: Invalid Application Password**
- [ ] Revoke Application Password in WordPress
- [ ] Try to upload → See authentication error
- [ ] Sign out and create new Application Password
- [ ] Uploads work again

**Test: Special Characters**
- [ ] Test with files containing special characters in filename
- [ ] Test with files containing unicode characters
- [ ] Verify uploads succeed

## Security Testing

### Keychain Storage
1. Authenticate successfully
2. Open Keychain Access app
3. Search for "com.wordup.wordpress"
4. Verify Application Password is stored securely
5. Verify password is not stored in plain text anywhere

### HTTPS Enforcement
1. Try using http:// (non-secure) site URL
2. Verify app works but warns about security
3. Recommend using https:// in production

### Memory Safety
1. Monitor Console.app while using app
2. Look for crashes or memory issues
3. Test with large files
4. Test with many sequential uploads

## Performance Testing

**Test: Upload Speed**
- [ ] Upload 1MB file → Should complete in reasonable time
- [ ] Upload 5MB file → Should complete without timeout
- [ ] Upload 10MB+ file → Should handle appropriately

**Test: Multiple Sequential Uploads**
- [ ] Upload 10 files in quick succession
- [ ] Verify all upload successfully
- [ ] No memory leaks or performance degradation

**Test: App Responsiveness**
- [ ] Upload large file
- [ ] Try clicking menu during upload
- [ ] Verify UI remains responsive

## WordPress Compatibility Testing

Test with different WordPress configurations:

**WordPress Versions**
- [ ] WordPress 5.6 (minimum)
- [ ] WordPress 6.0
- [ ] Latest WordPress version

**Hosting Environments**
- [ ] Shared hosting
- [ ] VPS/dedicated server
- [ ] Local development (wp-env, Local by Flywheel)

**WordPress Configurations**
- [ ] Default REST API prefix (/wp-json/)
- [ ] Custom permalink structure
- [ ] Multisite installation
- [ ] With security plugins (WordFence, etc.)

## Bug Reporting

When reporting bugs, include:
- macOS version
- WordPress version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Console.app logs (filter for "WordUp")
- Screenshots if applicable

## Test Environment Setup

### Local WordPress for Testing

Using wp-env:
```bash
npm -g install @wordpress/env
mkdir wordpress-test
cd wordpress-test
wp-env start
```

This creates a local WordPress at http://localhost:8888
- Username: admin
- Password: password

Generate an Application Password and test WordUp against it.

## Automated Testing

Currently, WordUp does not have automated tests. Future improvements could include:

1. Unit tests for:
   - URL construction
   - Authentication logic
   - Keychain operations
   - Error handling

2. Integration tests for:
   - WordPress API communication
   - File upload flow
   - Authentication flow

3. UI tests for:
   - Menu interactions
   - Drag and drop
   - Window management

## Continuous Integration

The project structure supports building on macOS runners:
- GitHub Actions with macOS runner
- Build with `swift build`
- Could add automated testing in CI

---

After completing manual testing, please update this document with any new test cases discovered or edge cases found.
