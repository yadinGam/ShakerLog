import Foundation

public enum LogLevel: Int, Sendable, Comparable, CaseIterable {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    case critical = 4

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public var label: String {
        switch self {
        case .debug: "DEBUG"
        case .info: "INFO"
        case .warning: "WARNING"
        case .error: "ERROR"
        case .critical: "CRITICAL"
        }
    }

    public var emoji: String {
        switch self {
        case .debug: "🔍"
        case .info: "ℹ️"
        case .warning: "⚠️"
        case .error: "❌"
        case .critical: "🔥"
        }
    }
}
