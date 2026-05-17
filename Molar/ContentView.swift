import SwiftUI

struct ContentView: View {
    @State private var session = BrushingSession()

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            switch session.state {
            case .idle:
                StartView(session: session)
                    .transition(.opacity)
            case .running, .paused:
                BrushingView(session: session)
                    .transition(.opacity)
            case .completed:
                CompletionView(session: session)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: session.state)
    }
}

#Preview {
    ContentView()
}
