import SwiftUI

struct BrushingView: View {
    @Bindable var session: BrushingSession

    var body: some View {
        VStack(spacing: 20) {
            FrameProgressBar(progress: session.overallProgress)
                .padding(.horizontal, 20)

            stepImage

            countdown

            Spacer().frame(maxHeight: 40)

            controls
        }
        .padding(.top, 8)
        .padding(.bottom, 17)
    }

    private var stepImage: some View {
        ZStack {
            Image("Step\(session.currentZoneIndex + 1)")
                .resizable()
                .scaledToFit()
                .id(session.currentZoneIndex)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
        }
        .frame(maxWidth: .infinity)
        .clipped()
        .animation(.easeInOut(duration: 0.35), value: session.currentZoneIndex)
    }

    private var countdown: some View {
        let s = session.secondsRemaining
        let tens: String? = s >= 10 ? String(s / 10) : nil
        let ones = String(s % 10)

        return HStack(spacing: 4) {
            if let tens {
                digitImage(tens)
                    .id("tens-\(tens)")
                    .transition(digitTransition)
            }
            digitImage(ones)
                .id("ones-\(ones)")
                .transition(digitTransition)
        }
        .animation(.easeInOut(duration: 0.3), value: s)
        .accessibilityLabel("\(s) seconds remaining")
    }

    private func digitImage(_ d: String) -> some View {
        Image("Digit\(d)")
            .resizable()
            .scaledToFit()
            .frame(height: 96)
    }

    private var digitTransition: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: DigitShift(offset: 30, blur: 8, opacity: 0),
                identity: DigitShift(offset: 0, blur: 0, opacity: 1)
            ),
            removal: .modifier(
                active: DigitShift(offset: -30, blur: 8, opacity: 0),
                identity: DigitShift(offset: 0, blur: 0, opacity: 1)
            )
        )
    }

    private struct DigitShift: ViewModifier {
        let offset: CGFloat
        let blur: CGFloat
        let opacity: Double
        func body(content: Content) -> some View {
            content
                .offset(y: offset)
                .blur(radius: blur)
                .opacity(opacity)
        }
    }

    private var controls: some View {
        HStack(spacing: 24) {
            controlButton(image: "BtnStop", label: "Stop") {
                session.reset()
            }

            controlButton(
                image: session.state == .running ? "BtnPause" : "BtnPlay",
                label: session.state == .running ? "Pause" : "Resume"
            ) {
                if session.state == .running {
                    session.pause()
                } else {
                    session.resume()
                }
            }

            controlButton(image: "BtnSkip", label: "Skip") {
                session.skipToNextZone()
            }
        }
        .padding(.horizontal, 24)
        .scaleEffect(0.75)
    }

    private func controlButton(image: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(BouncyImageButtonStyle())
        .accessibilityLabel(label)
    }
}

#Preview {
    BrushingView(session: {
        let s = BrushingSession()
        s.start()
        return s
    }())
}

struct FrameProgressBar: View {
    let progress: Double

    // Inner cutout measured from frame_loader.png (2000×203)
    private static let leftFrac:   CGFloat = 0.030
    private static let rightFrac:  CGFloat = 0.037
    private static let topFrac:    CGFloat = 0.197
    private static let bottomFrac: CGFloat = 0.517
    private static let aspect:     CGFloat = 2000.0 / 203.0

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let innerX = w * Self.leftFrac
            let innerY = h * Self.topFrac
            let innerW = w * (1 - Self.leftFrac - Self.rightFrac)
            let innerH = h * (1 - Self.topFrac - Self.bottomFrac)
            let clamped = max(0, min(1, progress))

            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: innerW * clamped, height: innerH + 10)
                    .offset(x: innerX, y: innerY - 5)
                    .animation(.easeInOut(duration: 0.25), value: clamped)

                Image("FrameLoader")
                    .resizable()
                    .frame(width: w, height: h)
            }
        }
        .aspectRatio(Self.aspect, contentMode: .fit)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(progress * 100)) percent")
    }
}
