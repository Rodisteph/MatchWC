import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    @State private var rotation = 0.0
    @State private var scale = 0.2
    @State private var opacity = 1.0
    @State private var titleOpacity = 0.0

    var body: some View {
        if isActive {
            MatchListView()
        } else {
            splashScreen
                .task { await startAnimation() }
        }
    }

    private var splashScreen: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.18, blue: 0.06), .black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()
                Text("MATCH WC")
                    .font(.headline)
                    .tracking(8)
                    .foregroundStyle(.white.opacity(0.55))
                    .opacity(titleOpacity)
                    .padding(.bottom, 64)
            }

            Image(systemName: "soccerball")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundStyle(.white)
                .rotationEffect(.degrees(rotation))
                .scaleEffect(scale)
                .shadow(color: .green.opacity(0.6), radius: 40)
                .opacity(opacity)
        }
    }

    private func startAnimation() async {
        withAnimation(.easeIn(duration: 0.5)) { titleOpacity = 1.0 }
        withAnimation(.easeIn(duration: 2.0)) {
            rotation = 1080
            scale = 8.0
        }
        try? await Task.sleep(for: .seconds(1.8))
        withAnimation(.easeOut(duration: 0.3)) {
            opacity = 0
            titleOpacity = 0
        }
        try? await Task.sleep(for: .seconds(0.3))
        isActive = true
    }
}

#Preview {
    ContentView()
}
