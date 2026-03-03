#if canImport(UIKit)
import SwiftUI

struct LogViewerView: View {
    @StateObject var viewModel: LogViewerViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                levelFilterBar
                Divider()
                logList
            }
            .searchable(text: $viewModel.searchText, prompt: "Search logs...")
            .navigationTitle("ShakerLog")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    menuButton
                }
            }
            .overlay(alignment: .bottom) { toastOverlay }
        }
        .onAppear { viewModel.loadEntries() }
    }

    // MARK: - Subviews

    private var levelFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: "All",
                    count: viewModel.totalCount,
                    isSelected: viewModel.selectedLevel == nil
                ) {
                    viewModel.clearSelectedLevel()
                }
                ForEach(LogLevel.allCases, id: \.self) { level in
                    FilterChip(
                        title: "\(level.emoji) \(level.label)",
                        count: viewModel.count(for: level),
                        isSelected: viewModel.selectedLevel == level
                    ) {
                        viewModel.toggleLevel(level)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    private var logList: some View {
        if viewModel.filteredEntries.isEmpty {
            VStack(spacing: 12) {
                Spacer()
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                Text("No logs found")
                    .foregroundColor(.secondary)
                Spacer()
            }
        } else {
            List(viewModel.filteredEntries) { entry in
                LogEntryRow(entry: entry)
                    .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .contextMenu {
                        Button {
                            viewModel.copyEntry(entry)
                        } label: {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }
            }
            .listStyle(.plain)
        }
    }

    private var menuButton: some View {
        Menu {
            Button {
                viewModel.copyAllLogs()
            } label: {
                Label("Copy All", systemImage: "doc.on.doc")
            }

            Button {
                viewModel.loadEntries()
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }

            Divider()

            Button(role: .destructive) {
                viewModel.clearLogs()
            } label: {
                Label("Clear Logs", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }

    @ViewBuilder
    private var toastOverlay: some View {
        if viewModel.copiedToast {
            Text("Copied to clipboard")
                .font(.caption)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(.bottom, 32)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}
#endif
