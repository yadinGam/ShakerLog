import Foundation

enum LogFormatter {
    static func format(_ entry: LogEntry) -> String {
        let time = entry.timestamp.formatted(
            .dateTime.hour().minute().second().secondFraction(.fractional(3))
        )
        return "\(entry.level.emoji) [\(time)] [\(entry.level.label)] \(entry.message) (\(entry.fileName):\(entry.line))"
    }
}
