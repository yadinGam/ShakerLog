#if canImport(UIKit)
import SwiftUI

struct ShakerLogModifier: ViewModifier {
    @State private var isPresented = false

    func body(content: Content) -> some View {
        content
            .background(
                ShakeDetectorView {
                    guard ShakerLog.shared.isEnabled else { return }
                    isPresented = true
                }
            )
            .sheet(isPresented: $isPresented) {
                LogViewerView(
                    viewModel: LogViewerViewModel(store: ShakerLog.shared.store)
                )
            }
    }
}

public extension View {
    func enableShakerLog() -> some View {
        modifier(ShakerLogModifier())
    }
}
#endif
