import SwiftUI
import WidgetKit

struct StandingsEntry: TimelineEntry {
  let date: Date
  let hasData: Bool
  let season: String
  let round: String
  let rows: [(code: String, points: String)]
}

struct StandingsProvider: TimelineProvider {
  func placeholder(in context: Context) -> StandingsEntry {
    makeEntry()
  }

  func getSnapshot(in context: Context, completion: @escaping (StandingsEntry) -> Void) {
    completion(makeEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<StandingsEntry>) -> Void) {
    let entry = makeEntry()
    let refresh = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
    completion(Timeline(entries: [entry], policy: .after(refresh)))
  }

  private func makeEntry() -> StandingsEntry {
    let store = WidgetSharedStore.self
    var rows: [(String, String)] = []
    for i in 1...3 {
      let code = store.string("standings_d\(i)_code")
      let pts = store.string("standings_d\(i)_points")
      rows.append((code.isEmpty ? "—" : code, pts))
    }
    return StandingsEntry(
      date: Date(),
      hasData: store.bool("standings_has_data"),
      season: store.string("standings_season"),
      round: store.string("standings_round"),
      rows: rows
    )
  }
}

struct StandingsWidget: Widget {
  let kind = "StandingsWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: StandingsProvider()) { entry in
      StandingsWidgetView(entry: entry)
        .widgetBackground(F1WidgetStyle.bg)
    }
    .configurationDisplayName("Standings")
    .description("Current drivers championship top 3")
    .supportedFamilies([.systemMedium])
  }
}

struct StandingsWidgetView: View {
  let entry: StandingsEntry

  private let placeColors: [Color] = [
    F1WidgetStyle.brandRed,
    F1WidgetStyle.place2,
    F1WidgetStyle.place3,
  ]

  var body: some View {
    if !entry.hasData {
      Text("Open F1 App to load data")
        .font(.system(size: 12))
        .foregroundColor(F1WidgetStyle.muted)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    } else {
      VStack(alignment: .leading, spacing: 0) {
        Text("STANDINGS")
          .font(.system(size: 10, weight: .bold))
          .foregroundColor(F1WidgetStyle.brandRed)
          .tracking(0.8)

        Text(subtitle)
          .font(.system(size: 10))
          .foregroundColor(F1WidgetStyle.muted)
          .padding(.top, 2)

        VStack(spacing: 0) {
          ForEach(Array(entry.rows.enumerated()), id: \.offset) { index, row in
            HStack(spacing: 6) {
              Text("\(index + 1)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(placeColors[min(index, placeColors.count - 1)])
                .frame(width: 16, alignment: .leading)
              Text(row.code)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
              Spacer(minLength: 4)
              Text(row.points)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
            }
            .padding(.vertical, 3)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.top, 4)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding(.leading, 10)
      .padding(.trailing, 16)
      .padding(.top, 14)
      .padding(.bottom, 10)
    }
  }

  private var subtitle: String {
    if !entry.season.isEmpty && !entry.round.isEmpty {
      return "\(entry.season) · R\(entry.round)"
    }
    if !entry.season.isEmpty {
      return entry.season
    }
    return "Drivers"
  }
}
