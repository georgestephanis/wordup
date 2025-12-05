import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var authWindow: NSWindow?
    var dropView: DragDropView!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "arrow.up.doc.fill", accessibilityDescription: "WordUp")
            button.action = #selector(togglePopover)
            button.target = self
            
            // Create custom view for drag and drop
            dropView = DragDropView(frame: button.bounds)
            dropView.appDelegate = self
            button.addSubview(dropView)
        }
        
        // Create popover with menu
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 200)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: MenuView(appDelegate: self))
        
        // Check if authenticated
        if !WordPressAuth.shared.isAuthenticated() {
            showAuthWindow()
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
    func showAuthWindow() {
        let contentView = AuthenticationView(appDelegate: self)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "WordUp - WordPress Authentication"
        window.contentView = NSHostingController(rootView: contentView).view
        window.center()
        window.makeKeyAndOrderFront(nil)
        authWindow = window
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closeAuthWindow() {
        authWindow?.close()
        authWindow = nil
    }
    
    func uploadFile(_ url: URL) {
        Task {
            do {
                let mediaURL = try await WordPressAPI.shared.uploadFile(url)
                
                // Copy URL to clipboard
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(mediaURL, forType: .string)
                
                // Show notification
                showNotification(title: "Upload Successful", message: "URL copied to clipboard")
            } catch {
                showNotification(title: "Upload Failed", message: error.localizedDescription)
            }
        }
    }
    
    func showNotification(title: String, message: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
}

// MARK: - Custom Drag and Drop View
class DragDropView: NSView {
    weak var appDelegate: AppDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        registerForDraggedTypes([.fileURL])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([.fileURL])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let items = sender.draggingPasteboard.pasteboardItems else { return false }
        
        for item in items {
            if let urlString = item.string(forType: .fileURL),
               let url = URL(string: urlString) {
                appDelegate?.uploadFile(url)
            }
        }
        
        return true
    }
}
