#if canImport(UIKit)
import SwiftUI
import UIKit

struct ShakeDetectorView: UIViewControllerRepresentable {
    let onShake: () -> Void

    func makeUIViewController(context: Context) -> ShakeDetectorViewController {
        let vc = ShakeDetectorViewController()
        vc.onShake = onShake
        return vc
    }

    func updateUIViewController(_ uiViewController: ShakeDetectorViewController, context: Context) {
        uiViewController.onShake = onShake
    }
}

final class ShakeDetectorViewController: UIViewController {
    var onShake: (() -> Void)?

    override var canBecomeFirstResponder: Bool { true }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            onShake?()
        }
    }
}
#endif
