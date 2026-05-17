import SwiftUI

struct StartView: View {
    @Bindable var session: BrushingSession

    var body: some View {
        VStack(spacing: 0) {
            Image("ToothIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityHidden(true)

            Button {
                session.start()
            } label: {
                Image("BtnPlay")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 126, height: 126)
            }
            .buttonStyle(BouncyImageButtonStyle())
            .accessibilityLabel("Start")
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    StartView(session: BrushingSession())
}
