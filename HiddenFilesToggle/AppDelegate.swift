import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    // The icon in the menu bar. We keep a reference so it doesn't disappear.
    var statusItem: NSStatusItem!

    // The menu shown on left-click, and its first line (the current state).
    let menu = NSMenu()
    let stateMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the menu bar icon.
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        // Tell the icon's button to call iconClicked for left AND right clicks.
        if let button = statusItem.button {
            button.target = self
            button.action = #selector(iconClicked)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        // Build the menu: current state, Toggle Hidden Files, Quit.
        menu.delegate = self
        menu.addItem(stateMenuItem)
        menu.addItem(.separator())
        let toggleItem = NSMenuItem(title: "Toggle Hidden Files", action: #selector(toggleHiddenFiles), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        // Show Finder's current state right away.
        updateDisplay()
    }

    // Called for every click on the menu bar icon.
    @objc func iconClicked() {
        if NSApp.currentEvent?.type == .rightMouseUp {
            // Right-click: toggle instantly.
            toggleHiddenFiles()
        } else {
            // Left-click: attach the menu just long enough to show it.
            // (If the menu stayed attached, right-clicks would open it too.)
            statusItem.menu = menu
            statusItem.button?.performClick(nil)
            statusItem.menu = nil
        }
    }

    @objc func toggleHiddenFiles() {
        HiddenFiles.toggle()
        updateDisplay()
    }

    // Called just before the menu opens, so the state line is always fresh
    // (for example if you pressed Cmd+Shift+. in Finder).
    func menuWillOpen(_ menu: NSMenu) {
        updateDisplay()
    }

    // Reads Finder's state and updates the icon and the menu text to match.
    func updateDisplay() {
        let shown = HiddenFiles.areShown()

        let symbolName = shown ? "eye" : "eye.slash"
        let description = shown ? "Hidden files: shown" : "Hidden files: not shown"

        statusItem.button?.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: description)
        statusItem.button?.toolTip = description
        stateMenuItem.title = description
    }
}
