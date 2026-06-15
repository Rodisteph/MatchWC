import SwiftUI

struct MatchListView: View {
    @State private var viewModel = MatchViewModel()
    @State private var hasLoaded = false
    @State private var isRefreshing = false

    private struct MatchSection: Identifiable {
        let id: String
        let title: String
        let color: Color
        let matches: [Match]
    }

    private var sections: [MatchSection] {
        let live   = viewModel.matches.filter { ["IN_PLAY", "LIVE"].contains($0.status) }
        let paused = viewModel.matches.filter { $0.status == "PAUSED" }
        let done   = viewModel.matches.filter { $0.status == "FINISHED" }
        let other  = viewModel.matches.filter { !["IN_PLAY", "LIVE", "PAUSED", "FINISHED"].contains($0.status) }
        return [
            live.isEmpty   ? nil : MatchSection(id: "live",   title: "EN DIRECT", color: .red,       matches: live),
            paused.isEmpty ? nil : MatchSection(id: "paused", title: "MI-TEMPS",  color: .orange,    matches: paused),
            done.isEmpty   ? nil : MatchSection(id: "done",   title: "TERMINÉS",  color: .secondary, matches: done),
            other.isEmpty  ? nil : MatchSection(id: "other",  title: "À VENIR",   color: .blue,      matches: other),
        ].compactMap { $0 }
    }

    private var liveCount: Int {
        viewModel.matches.filter { ["IN_PLAY", "LIVE"].contains($0.status) }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                matchList
            }
            .overlay { stateOverlay }
            .navigationTitle("En direct")
            .toolbar { toolbarContent }
            .task {
                await viewModel.load()
                withAnimation(.easeOut(duration: 0.4)) { hasLoaded = true }
            }
        }
    }

    

    private var matchList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                if hasLoaded {
                    ForEach(sections) { section in
                        SectionHeaderView(title: section.title, color: section.color)
                            .padding(.horizontal)
                            .padding(.top, 16)
                            .padding(.bottom, 8)

                        ForEach(Array(section.matches.enumerated()), id: \.element.id) { index, match in
                            MatchCard(match: match)
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                                .animation(
                                    .easeOut(duration: 0.35).delay(Double(index) * 0.04),
                                    value: hasLoaded
                                )
                        }
                    }
                    .padding(.bottom, 12)
                } else {
                    ForEach(0..<4, id: \.self) { _ in
                        SkeletonMatchCard()
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                    }
                    .padding(.top, 16)
                }
            }
        }
        .refreshable { await viewModel.load() }
    }

    // MARK: Overlay

    @ViewBuilder
    private var stateOverlay: some View {
        if hasLoaded && viewModel.matches.isEmpty {
            if viewModel.errorMessage != nil {
                ContentUnavailableView {
                    Label("Erreur de chargement", systemImage: "wifi.slash")
                } description: {
                    Text("Vérifiez votre connexion et réessayez.")
                }
            } else {
                ContentUnavailableView {
                    Label("Aucun match", systemImage: "sportscourt")
                } description: {
                    Text("Aucun match en direct pour le moment.")
                }
            }
        }
    }

    

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if liveCount > 0 {
            ToolbarItem(placement: .navigationBarLeading) {
                LiveBadge(count: liveCount)
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                Task {
                    isRefreshing = true
                    await viewModel.load()
                    isRefreshing = false
                }
            } label: {
                Image(systemName: "arrow.clockwise")
                    .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                    .animation(
                        isRefreshing
                            ? .linear(duration: 0.6).repeatForever(autoreverses: false)
                            : .default,
                        value: isRefreshing
                    )
            }
        }
    }
}

#Preview {
    MatchListView()
}
