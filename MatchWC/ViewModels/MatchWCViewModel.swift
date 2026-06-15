import Foundation

@Observable
@MainActor
final class MatchViewModel {
    var matches: [Match] = []
    var errorMessage: String?

    private let service = MatchService()

    func load() async {
        do {
            matches = try await service.fetchLiveMatches()
            errorMessage = nil
        } catch {
            errorMessage = "Impossible de charger les matchs : \(error.localizedDescription)"
        }
    }
}

