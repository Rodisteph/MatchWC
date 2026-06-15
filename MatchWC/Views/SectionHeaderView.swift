import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.caption2.bold())
            .tracking(1.5)
            .foregroundStyle(color == .secondary ? AnyShapeStyle(.secondary) : AnyShapeStyle(color))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                color == .secondary
                    ? AnyShapeStyle(Color(.tertiarySystemFill))
                    : AnyShapeStyle(color.opacity(0.12)),
                in: Capsule()
            )
    }
}
