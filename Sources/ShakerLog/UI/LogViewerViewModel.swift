#if canImport(UIKit)
import SwiftUI
import UIKit

@MainActor
final class LogViewerViewModel: ObservableObject {

    // MARK: - Published State

    @Published var entries: [LogEntry] = []
    @Published var selectedLevel: LogLevel?
    @Published var searchText = ""
    @Published private(set) var copiedToast = false

    // MARK: - Dependencies

    private let store: LogStore

    // MARK: - Computed

    var filteredEntries: [LogEntry] {
        var result = entries
        if let level = selectedLevel {
            result = result.filter { $0.level == level }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.message.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result.reversed()
    }

    var totalCount: Int { entries.count }

    func count(for level: LogLevel) -> Int {
        entries.filter { $0.level == level }.count
    }

    // MARK: - Init

    init(store: LogStore) {
        self.store = store
    }

    // MARK: - Actions

    func loadEntries() {
        entries = store.allEntries()
    }

    func toggleLevel(_ level: LogLevel) {
        selectedLevel = (selectedLevel == level) ? nil : level
    }

    func clearSelectedLevel() {
        selectedLevel = nil
    }

    func clearLogs() {
        store.clear()
        entries = []
    }

    func copyEntry(_ entry: LogEntry) {
        UIPasteboard.general.string = LogFormatter.format(entry)
    }

    func copyAllLogs() {
        let text = filteredEntries
            .map { LogFormatter.format($0) }
            .joined(separator: "\n")
        UIPasteboard.general.string = text
        withAnimation { copiedToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            withAnimation { self?.copiedToast = false }
        }
    }
}
#endif
