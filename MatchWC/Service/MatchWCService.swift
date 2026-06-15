import Foundation

struct MatchService {
    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
        
    }

    func fetchLiveMatches() async throws -> [Match] {
        let url = URL(string: "https://api.football-data.org/v4/competitions/WC/matches?status=LIVE")!

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(MatchesResponse.self, from: data)
        response.matches.forEach {
                print("🏳️", $0.homeTeam.name ?? "?", "→ crest:", $0.homeTeam.crest ?? "NIL")
            }
        return response.matches
    }
}

