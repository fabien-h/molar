import SwiftUI
import AVFoundation

struct CompletionView: View {
    @Bindable var session: BrushingSession
    @State private var trophyAppeared = false
    @State private var player: AVAudioPlayer?

    var body: some View {
        VStack(spacing: 0) {
            Image("Trophy")
                .resizable()
                .scaledToFit()
                .frame(width: 260, height: 260)
                .scaleEffect(trophyAppeared ? 1.0 : 0.0)
                .animation(.spring(response: 0.55, dampingFraction: 0.5), value: trophyAppeared)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityHidden(true)
                .onAppear {
                    trophyAppeared = true
                    playRandomCheer()
                }

            Button {
                session.reset()
            } label: {
                Image("BtnThumb")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 126, height: 126)
            }
            .buttonStyle(BouncyImageButtonStyle())
            .accessibilityLabel("Brush again")
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func playRandomCheer() {
        let index = Int.random(in: 1...7)
        guard let url = Bundle.main.url(forResource: "s\(index)", withExtension: "mp3") else { return }
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        player?.play()
    }
}

#Preview {
    CompletionView(session: BrushingSession())
}
