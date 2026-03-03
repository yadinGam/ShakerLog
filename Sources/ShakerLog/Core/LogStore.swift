import Foundation

final class LogStore: @unchecked Sendable {
    private let lock = NSLock()
    private var entries: [LogEntry] = []
    private var maxEntries: Int = 1000

    func setMaxEntries(_ max: Int) {
        lock.lock()
        defer { lock.unlock() }
        maxEntries = max
    }

    func add(_ entry: LogEntry) {
        lock.lock()
        defer { lock.unlock() }
        entries.append(entry)
        if entries.count > maxEntries {
            entries.removeFirst(entries.count - maxEntries)
        }
    }

    func allEntries() -> [LogEntry] {
        lock.lock()
        defer { lock.unlock() }
        return entries
    }

    func clear() {
        lock.lock()
        defer { lock.unlock() }
        entries.removeAll()
    }
}
