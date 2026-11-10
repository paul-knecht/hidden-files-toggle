import Foundation

// Everything that talks to the real Finder lives here.
enum HiddenFiles {

    // True if Finder is set to show hidden files.
    // If the setting was never changed, `defaults read` prints an error
    // instead of a value, and we treat that as "not shown".
    static func areShown() -> Bool {
        let output = run("/usr/bin/defaults", ["read", "com.apple.finder", "AppleShowAllFiles"])
        return ["1", "true", "yes"].contains(output.lowercased())
    }

    // Switches Finder to the opposite setting and restarts it,
    // because Finder only reads this setting when it starts.
    static func toggle() {
        let newValue = areShown() ? "false" : "true"
        run("/usr/bin/defaults", ["write", "com.apple.finder", "AppleShowAllFiles", "-bool", newValue])
        run("/usr/bin/killall", ["Finder"])
    }

    // Runs a command line tool, waits for it to finish, and returns what it printed.
    @discardableResult
    private static func run(_ tool: String, _ arguments: [String]) -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: tool)
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()

        do {
            try process.run()
        } catch {
            return ""
        }
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let text = String(data: data, encoding: .utf8) ?? ""
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
