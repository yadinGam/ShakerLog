import Foundation

public final class ShakerLog: @unchecked Sendable {
    public static let shared = ShakerLog()

    let store = LogStore()
    private let lock = NSLock()
    private var _minimumLevel: LogLevel = .debug
    private var _isEnabled = false
    private var _printToConsole = true

    private init() {}

    // MARK: - Configuration

    public struct Configuration: Sendable {
        public var minimumLevel: LogLevel
        public var maxEntries: Int
        public var printToConsole: Bool

        public init(
            minimumLevel: LogLevel = .debug,
            maxEntries: Int = 1000,
            printToConsole: Bool = true
        ) {
            self.minimumLevel = minimumLevel
            self.maxEntries = maxEntries
            self.printToConsole = printToConsole
        }
    }

    public static func configure(_ configuration: Configuration = Configuration()) {
        let instance = shared
        instance.lock.lock()
        instance._minimumLevel = configuration.minimumLevel
        instance._isEnabled = true
        instance._printToConsole = configuration.printToConsole
        instance.lock.unlock()
        instance.store.setMaxEntries(configuration.maxEntries)
    }

    // MARK: - Logging

    public static func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        shared.log(level: .debug, message: message, file: file, function: function, line: line)
    }

    public static func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        shared.log(level: .info, message: message, file: file, function: function, line: line)
    }

    public static func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        shared.log(level: .warning, message: message, file: file, function: function, line: line)
    }

    public static func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        shared.log(level: .error, message: message, file: file, function: function, line: line)
    }

    public static func critical(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        shared.log(level: .critical, message: message, file: file, function: function, line: line)
    }

    // MARK: - Access

    public static func allEntries() -> [LogEntry] {
        shared.store.allEntries()
    }

    public static func clearAll() {
        shared.store.clear()
    }

    // MARK: - Internal

    var isEnabled: Bool {
        lock.lock()
        defer { lock.unlock() }
        return _isEnabled
    }

    private func log(level: LogLevel, message: String, file: String, function: String, line: Int) {
        lock.lock()
        let minLevel = _minimumLevel
        let enabled = _isEnabled
        let printConsole = _printToConsole
        lock.unlock()

        guard enabled, level >= minLevel else { return }

        let entry = LogEntry(level: level, message: message, file: file, function: function, line: line)
        store.add(entry)

        if printConsole {
            print(LogFormatter.format(entry))
        }
    }
}
