import Foundation

public struct LogEntry: Identifiable, Sendable {
    public let id: UUID
    public let timestamp: Date
    public let level: LogLevel
    public let message: String
    public let file: String
    public let function: String
    public let line: Int

    init(
        level: LogLevel,
        message: String,
        file: String,
        function: String,
        line: Int
    ) {
        self.id = UUID()
        self.timestamp = Date()
        self.level = level
        self.message = message
        self.file = file
        self.function = function
        self.line = line
    }

    public var fileName: String {
        (file as NSString).lastPathComponent
    }
}
