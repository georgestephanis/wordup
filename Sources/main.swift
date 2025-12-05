import Cocoa

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// Configure app to run in menu bar only
app.setActivationPolicy(.accessory)

app.run()
