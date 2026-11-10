# HiddenFilesToggle

A tiny macOS menu bar app that shows or hides hidden files in Finder.

- The menu bar icon shows the current state.
- **Right-click** the icon to toggle instantly.
- **Left-click** opens a small menu: current state, "Toggle Hidden Files", "Quit".
- No Dock icon; the app lives only in the menu bar.

Finder restarts briefly on each toggle, because that is how it picks up
the setting. Finder also has a built-in shortcut for the same thing:
`⇧⌘.` in any Finder window.

## Why I built it

Hidden folders matter when I build with Claude Code, for example `.claude`, so I wanted a one-click switch.

Built with [Claude Code](https://claude.com/claude-code) while learning Swift, Xcode and Git.

## How it works

It runs `defaults write com.apple.finder AppleShowAllFiles -bool true/false`
followed by `killall Finder`, and reads the current value on launch.

## Build

Open `HiddenFilesToggle.xcodeproj` in Xcode and press Run, or:

```bash
xcodebuild -project HiddenFilesToggle.xcodeproj -scheme HiddenFilesToggle -derivedDataPath build build
```

Requires macOS 13 or later. Written in Swift with AppKit.

## Licence

MIT, see [LICENSE](LICENSE).
