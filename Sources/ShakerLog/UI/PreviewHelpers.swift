#if canImport(UIKit)
#if DEBUG
import SwiftUI

extension LogStore {
    static var preview: LogStore {
        let store = LogStore()
        let samples: [(LogLevel, String)] = [
            (.critical, "Unrecoverable auth state - forcing logout"),
            (.error, "Network request failed: timeout after 30s"),
            (.error, "Failed to decode JSON: keyNotFound(\"email\")"),
            (.warning, "API response took 2.3s (threshold: 2.0s)"),
            (.warning, "Low disk space: 128MB remaining"),
            (.info, "User logged in: user@example.com"),
            (.info, "Fetching products from API"),
            (.info, "Received 42 products from server"),
            (.debug, "ViewDidLoad called"),
            (.debug, "Layout subviews completed"),
            (.info, "Image cache hit for avatar.png"),
            (.warning, "Retry attempt 2/3 for payment API"),
            (.error, "Push notification registration failed"),
            (.debug, "Dark mode enabled by user"),
            (.info, "Analytics event sent: purchase_completed"),
        ]
        for (level, message) in samples {
            store.add(LogEntry(level: level, message: message, file: "ExampleView.swift", function: "test()", line: Int.random(in: 10...200)))
        }
        return store
    }
}

#Preview("Log Viewer - With Data") {
    LogViewerView(viewModel: LogViewerViewModel(store: .preview))
}

#Preview("Log Viewer - Empty") {
    LogViewerView(viewModel: LogViewerViewModel(store: LogStore()))
}
#endif
#endif
