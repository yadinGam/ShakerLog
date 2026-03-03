import SwiftUI
import ShakerLog

@main
struct ShakerLogDemoApp: App {
    init() {
        ShakerLog.configure(.init(
            minimumLevel: .debug,
            maxEntries: 500,
            printToConsole: true
        ))
        ShakerLog.info("App launched")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .enableShakerLog()
        }
    }
}
