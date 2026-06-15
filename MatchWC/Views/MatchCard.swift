import SwiftUI

struct MatchCard: View {
    let match: Match
    @State private var pulse = false

    private var isLive: Bool {
        ["IN_PLAY", "LIVE"].contains(match.status)
    }

    private var statusLabel: String? {
        switch match.status {
        case "IN_PLAY", "LIVE": return "EN DIRECT"
        case "PAUSED":          return "MI-TEMPS"
        case "FINISHED":        return "Terminé"
        default:                return nil
        }
    }

    // MARK: Flag dictionary

    private static let flagEmoji: [String: String] = [
        // Europe
        "Albania": "🇦🇱",
        "Andorra": "🇦🇩",
        "Armenia": "🇦🇲",
        "Austria": "🇦🇹",
        "Azerbaijan": "🇦🇿",
        "Belarus": "🇧🇾",
        "Belgium": "🇧🇪",
        "Bosnia and Herzegovina": "🇧🇦",
        "Bulgaria": "🇧🇬",
        "Croatia": "🇭🇷",
        "Cyprus": "🇨🇾",
        "Czech Republic": "🇨🇿",
        "Czechia": "🇨🇿",
        "Denmark": "🇩🇰",
        "England": "🏴󠁧󁢥󠁮󠁧󠁿",
        "Estonia": "🇪🇪",
        "Faroe Islands": "🇫🇴",
        "Finland": "🇫🇮",
        "France": "🇫🇷",
        "Georgia": "🇬🇪",
        "Germany": "🇩🇪",
        "Gibraltar": "🇬🇮",
        "Greece": "🇬🇷",
        "Hungary": "🇭🇺",
        "Iceland": "🇮🇸",
        "Ireland": "🇮🇪",
        "Republic of Ireland": "🇮🇪",
        "Israel": "🇮🇱",
        "Italy": "🇮🇹",
        "Kazakhstan": "🇰🇿",
        "Kosovo": "🇽🇰",
        "Latvia": "🇱🇻",
        "Liechtenstein": "🇱🇮",
        "Lithuania": "🇱🇹",
        "Luxembourg": "🇱🇺",
        "Malta": "🇲🇹",
        "Moldova": "🇲🇩",
        "Montenegro": "🇲🇪",
        "Netherlands": "🇳🇱",
        "North Macedonia": "🇲🇰",
        "Northern Ireland": "🇬🇧",
        "Norway": "🇳🇴",
        "Poland": "🇵🇱",
        "Portugal": "🇵🇹",
        "Romania": "🇷🇴",
        "Russia": "🇷🇺",
        "San Marino": "🇸🇲",
        "Scotland": "🏴󠁧󁢳󠁣󠁴󠁿",
        "Serbia": "🇷🇸",
        "Slovakia": "🇸🇰",
        "Slovenia": "🇸🇮",
        "Spain": "🇪🇸",
        "Sweden": "🇸🇪",
        "Switzerland": "🇨🇭",
        "Turkey": "🇹🇷",
        "Türkiye": "🇹🇷",
        "Ukraine": "🇺🇦",
        "Wales": "🏴󠁧󁢷󠁬󠁳󠁿",
        // South America
        "Argentina": "🇦🇷",
        "Bolivia": "🇧🇴",
        "Brazil": "🇧🇷",
        "Chile": "🇨🇱",
        "Colombia": "🇨🇴",
        "Ecuador": "🇪🇨",
        "Paraguay": "🇵🇾",
        "Peru": "🇵🇪",
        "Uruguay": "🇺🇾",
        "Venezuela": "🇻🇪",
        // North & Central America / Caribbean
        "Canada": "🇨🇦",
        "Costa Rica": "🇨🇷",
        "Cuba": "🇨🇺",
        "El Salvador": "🇸🇻",
        "Guatemala": "🇬🇹",
        "Haiti": "🇭🇹",
        "Honduras": "🇭🇳",
        "Jamaica": "🇯🇲",
        "Mexico": "🇲🇽",
        "Panama": "🇵🇦",
        "Trinidad and Tobago": "🇹🇹",
        "United States": "🇺🇸",
        "USA": "🇺🇸",
        // Africa
        "Algeria": "🇩🇿",
        "Angola": "🇦🇴",
        "Benin": "🇧🇯",
        "Burkina Faso": "🇧🇫",
        "Cameroon": "🇨🇲",
        "Cape Verde Islands": "🇨🇻",
        "Comoros": "🇰🇲",
        "Congo DR": "🇨🇩",
        "DR Congo": "🇨🇩",
        "Ivory Coast": "🇨🇮",
        "Côte d'Ivoire": "🇨🇮",
        "Egypt": "🇪🇬",
        "Equatorial Guinea": "🇬🇶",
        "Ethiopia": "🇪🇹",
        "Gabon": "🇬🇦",
        "Gambia": "🇬🇲",
        "Ghana": "🇬🇭",
        "Guinea": "🇬🇳",
        "Guinea-Bissau": "🇬🇼",
        "Kenya": "🇰🇪",
        "Libya": "🇱🇾",
        "Madagascar": "🇲🇬",
        "Malawi": "🇲🇼",
        "Mali": "🇲🇱",
        "Mauritania": "🇲🇷",
        "Morocco": "🇲🇦",
        "Mozambique": "🇲🇿",
        "Namibia": "🇳🇦",
        "Niger": "🇳🇪",
        "Nigeria": "🇳🇬",
        "Rwanda": "🇷🇼",
        "Senegal": "🇸🇳",
        "Sierra Leone": "🇸🇱",
        "South Africa": "🇿🇦",
        "Sudan": "🇸🇩",
        "Tanzania": "🇹🇿",
        "Togo": "🇹🇬",
        "Tunisia": "🇹🇳",
        "Uganda": "🇺🇬",
        "Zambia": "🇿🇲",
        "Zimbabwe": "🇿🇼",
        // Asia
        "Australia": "🇦🇺",
        "Bahrain": "🇧🇭",
        "Bangladesh": "🇧🇩",
        "China PR": "🇨🇳",
        "China": "🇨🇳",
        "Chinese Taipei": "🇹🇼",
        "Hong Kong": "🇭🇰",
        "India": "🇮🇳",
        "Indonesia": "🇮🇩",
        "Iran": "🇮🇷",
        "IR Iran": "🇮🇷",
        "Iraq": "🇮🇶",
        "Japan": "🇯🇵",
        "Jordan": "🇯🇴",
        "Korea Republic": "🇰🇷",
        "South Korea": "🇰🇷",
        "Kuwait": "🇰🇼",
        "Kyrgyzstan": "🇰🇬",
        "Lebanon": "🇱🇧",
        "Malaysia": "🇲🇾",
        "Maldives": "🇲🇻",
        "Mongolia": "🇲🇳",
        "Myanmar": "🇲🇲",
        "Nepal": "🇳🇵",
        "North Korea": "🇰🇵",
        "DPR Korea": "🇰🇵",
        "Oman": "🇴🇲",
        "Pakistan": "🇵🇰",
        "Palestine": "🇵🇸",
        "Philippines": "🇵🇭",
        "Qatar": "🇶🇦",
        "Saudi Arabia": "🇸🇦",
        "Singapore": "🇸🇬",
        "Sri Lanka": "🇱🇰",
        "Syria": "🇸🇾",
        "Tajikistan": "🇹🇯",
        "Thailand": "🇹🇭",
        "Timor-Leste": "🇹🇱",
        "Turkmenistan": "🇹🇲",
        "United Arab Emirates": "🇦🇪",
        "UAE": "🇦🇪",
        "Uzbekistan": "🇺🇿",
        "Vietnam": "🇻🇳",
        "Yemen": "🇾🇪",
        // Oceania
        "Fiji": "🇫🇯",
        "New Caledonia": "🇳🇨",
        "New Zealand": "🇳🇿",
        "Papua New Guinea": "🇵🇬",
        "Solomon Islands": "🇸🇧",
        "Tahiti": "🇵🇫",
        "Vanuatu": "🇻🇺",
    ]

    var body: some View {
        HStack(spacing: 0) {
            teamView(team: match.homeTeam, alignment: .trailing)
            scoreView
            teamView(team: match.awayTeam, alignment: .leading)
        }
        .padding(.vertical, 16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
        .onAppear { if isLive { pulse = true } }
    }

   

    private var scoreView: some View {
        VStack(spacing: 6) {
            if isLive {
                HStack(spacing: 5) {
                    Circle()
                        .fill(.red)
                        .frame(width: 7, height: 7)
                        .scaleEffect(pulse ? 1.4 : 0.8)
                        .animation(
                            .easeInOut(duration: 0.75).repeatForever(autoreverses: true),
                            value: pulse
                        )
                    Text("EN DIRECT")
                        .font(.caption2.bold())
                        .foregroundStyle(.red)
                }
            } else if let label = statusLabel {
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            if let home = match.score.fullTime.home,
               let away = match.score.fullTime.away {
                Text("\(home) – \(away)")
                    .font(.title2.bold())
                    .monospacedDigit()
            } else {
                Text("vs")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 90)
    }

    

    @ViewBuilder
    private func teamView(team: Team, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 8) {
            Text(Self.flagEmoji[team.name ?? ""] ?? "🏳️")
                .font(.system(size: 40))
                .frame(width: 36, height: 36)

            Text(team.name ?? "?")
                .font(.caption.weight(.medium))
                .multilineTextAlignment(alignment == .trailing ? .trailing : .leading)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
    }
}
