import SwiftUI

struct SkeletonMatchCard: View {
    @State private var shimmer = false

    var body: some View {
        HStack(spacing: 0) {
            skeletonTeam(alignment: .trailing)
            skeletonScore
            skeletonTeam(alignment: .leading)
        }
        .padding(.vertical, 16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
        .opacity(shimmer ? 0.45 : 1.0)
        .animation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true), value: shimmer)
        .onAppear { shimmer = true }
    }

    private var skeletonScore: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 3).frame(width: 32, height: 8)
            RoundedRectangle(cornerRadius: 6).frame(width: 64, height: 26)
        }
        .foregroundStyle(Color(.tertiarySystemFill))
        .frame(width: 90)
    }

    private func skeletonTeam(alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 8) {
            RoundedRectangle(cornerRadius: 8).frame(width: 36, height: 36)
            RoundedRectangle(cornerRadius: 4).frame(width: 56, height: 10)
        }
        .foregroundStyle(Color(.tertiarySystemFill))
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
    }
}
