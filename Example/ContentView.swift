import SwiftUI
import ShakerLog

struct ContentView: View {
    @State private var logCount = 0

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    headerSection
                    logButtonsSection
                    bulkSection
                    infoSection
                }
                .padding()
            }
            .navigationTitle("ShakerLog Demo")
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "waveform.badge.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.accentColor)
            Text("Shake the device to open the log viewer")
                .font(.headline)
                .multilineTextAlignment(.center)
            Text("Total logs: \(logCount)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 20)
    }

    private var logButtonsSection: some View {
        VStack(spacing: 12) {
            Text("Tap to create logs")
                .font(.subheadline)
                .foregroundColor(.secondary)

            LogButton(title: "Debug", color: .gray, icon: "magnifyingglass") {
                ShakerLog.debug("User tapped debug button")
                logCount += 1
            }

            LogButton(title: "Info", color: .blue, icon: "info.circle") {
                ShakerLog.info("User navigated to main screen")
                logCount += 1
            }

            LogButton(title: "Warning", color: .orange, icon: "exclamationmark.triangle") {
                ShakerLog.warning("Cache miss for key: user_profile")
                logCount += 1
            }

            LogButton(title: "Error", color: .red, icon: "xmark.circle") {
                ShakerLog.error("Network request failed: timeout after 30s")
                logCount += 1
            }

            LogButton(title: "Critical", color: .purple, icon: "flame") {
                ShakerLog.critical("Database corruption detected in users table")
                logCount += 1
            }
        }
    }

    private var bulkSection: some View {
        VStack(spacing: 12) {
            Divider()

            Button {
                generateSampleLogs()
            } label: {
                Label("Generate 20 Sample Logs", systemImage: "square.stack.3d.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Button(role: .destructive) {
                ShakerLog.clearAll()
                logCount = 0
            } label: {
                Label("Clear All Logs", systemImage: "trash")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.red)
                    .cornerRadius(12)
            }
        }
    }

    private var infoSection: some View {
        VStack(spacing: 4) {
            Divider()
            Text("On simulator: Device → Shake (⌃⌘Z)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Helpers

    private func generateSampleLogs() {
        let samples: [(LogLevel, String)] = [
            (.debug, "ViewDidLoad called"),
            (.debug, "Layout subviews completed"),
            (.info, "User logged in: user@example.com"),
            (.info, "Fetching products from API"),
            (.info, "Received 42 products"),
            (.info, "Image cache hit for avatar.png"),
            (.warning, "API response took 2.3s (threshold: 2.0s)"),
            (.warning, "Low disk space: 128MB remaining"),
            (.warning, "Retry attempt 2/3 for payment API"),
            (.error, "Failed to decode JSON: keyNotFound(\"email\")"),
            (.error, "Location permission denied"),
            (.error, "Push notification registration failed"),
            (.debug, "Dark mode enabled"),
            (.info, "App entered background"),
            (.info, "App became active"),
            (.warning, "Memory warning received"),
            (.error, "Socket disconnected unexpectedly"),
            (.critical, "Unrecoverable auth state - forcing logout"),
            (.debug, "Cleared image cache: freed 45MB"),
            (.info, "Analytics event sent: purchase_completed"),
        ]

        for (level, message) in samples {
            switch level {
            case .debug: ShakerLog.debug(message)
            case .info: ShakerLog.info(message)
            case .warning: ShakerLog.warning(message)
            case .error: ShakerLog.error(message)
            case .critical: ShakerLog.critical(message)
            }
        }
        logCount += samples.count
    }
}

// MARK: - Supporting Views

private struct LogButton: View {
    let title: String
    let color: Color
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(title)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(color.opacity(0.6))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}
