import Foundation

struct MatchesResponse: Codable {
    let matches: [Match]
}

struct Match: Codable, Identifiable {
    let id: Int
    let status: String
    let homeTeam: Team
    let awayTeam: Team
    let score: Score
}

struct Team: Codable {
    let name: String?
    let crest: String?   // URL du logo
}

struct Score: Codable {
    let fullTime: ScoreDetail
}

struct ScoreDetail: Codable {
    let home: Int?
    let away: Int?
}

