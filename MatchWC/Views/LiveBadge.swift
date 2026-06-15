import SwiftUI

struct LiveBadge: View {
    let count: Int
    @State private var pulse = false

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(.red)
                .frame(width: 6, height: 6)
                .scaleEffect(pulse ? 1.5 : 0.7)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulse)
            Text("\(count) live")
                .font(.caption.bold())
                .foregroundStyle(.red)
        }
        .onAppear { pulse = true }
    }
}
