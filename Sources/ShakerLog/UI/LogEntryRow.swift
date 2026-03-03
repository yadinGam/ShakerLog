#if canImport(UIKit)
import SwiftUI

struct LogEntryRow: View {
    let entry: LogEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.level.emoji)
                    .font(.caption)
                Text(entry.level.label)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(levelColor)
                Spacer()
                Text(
                    entry.timestamp.formatted(
                        .dateTime.hour().minute().second().secondFraction(.fractional(3))
                    )
                )
                .font(.caption2)
                .monospacedDigit()
                .foregroundColor(.secondary)
            }

            Text(entry.message)
                .font(.callout)

            Text("\(entry.fileName):\(entry.line)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }

    private var levelColor: Color {
        switch entry.level {
        case .debug: .gray
        case .info: .blue
        case .warning: .orange
        case .error: .red
        case .critical: .purple
        }
    }
}
#endif
