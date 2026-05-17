import SwiftUI
import UIKit

struct BouncyImageButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        BouncyButtonBody(configuration: configuration)
    }
}

private struct BouncyButtonBody: View {
    let configuration: ButtonStyle.Configuration
    @State private var appeared = false

    var body: some View {
        let scale: CGFloat = appeared
            ? (configuration.isPressed ? 0.95 : 1.0)
            : 0.0

        configuration.label
            .scaleEffect(scale)
            .animation(
                configuration.isPressed
                    ? .easeIn(duration: 0.08)
                    : .spring(response: 0.35, dampingFraction: 0.45),
                value: configuration.isPressed
            )
            .animation(.spring(response: 0.55, dampingFraction: 0.5), value: appeared)
            .onAppear { appeared = true }
            .onChange(of: configuration.isPressed) { wasPressed, isPressed in
                if wasPressed && !isPressed {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
    }
}
