import SwiftUI
import WidgetKit

struct NextGpEntry: TimelineEntry {
  let date: Date
  let hasData: Bool
  let raceName: String
  let circuit: String
  let targetDate: Date?
}

struct NextGpProvider: TimelineProvider {
  func placeholder(in context: Context) -> NextGpEntry {
    makeEntry()
  }

  func getSnapshot(in context: Context, completion: @escaping (NextGpEntry) -> Void) {
    completion(makeEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<NextGpEntry>) -> Void) {
    let entry = makeEntry()
    var refresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
    if let target = entry.targetDate, target > Date(), target < refresh {
      refresh = target
    }
    completion(Timeline(entries: [entry], policy: .after(refresh)))
  }

  private func makeEntry() -> NextGpEntry {
    let store = WidgetSharedStore.self
    let hasData = store.bool("next_gp_has_data")
    let raceName = store.string("next_gp_race_name")
    let circuit = store.string("next_gp_circuit")
    let targetMs = Int64(store.string("next_gp_target_ms")) ?? 0
    let targetDate = targetMs > 0 ? Date(timeIntervalSince1970: TimeInterval(targetMs) / 1000.0) : nil
    return NextGpEntry(
      date: Date(),
      hasData: hasData,
      raceName: raceName.isEmpty ? "Next GP" : raceName,
      circuit: circuit,
      targetDate: targetDate
    )
  }
}

struct NextGpWidget: Widget {
  let kind = "NextGpWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: NextGpProvider()) { entry in
      NextGpWidgetView(entry: entry)
        .widgetBackground(F1WidgetStyle.bg)
    }
    .configurationDisplayName("Next GP")
    .description("Countdown to the next Grand Prix weekend")
    .supportedFamilies([.systemMedium])
  }
}

struct NextGpWidgetView: View {
  let entry: NextGpEntry

  var body: some View {
    if !entry.hasData {
      Text("Open F1 App to load data")
        .font(.system(size: 12))
        .foregroundColor(F1WidgetStyle.muted)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    } else {
      VStack(alignment: .leading, spacing: 0) {
        Text("NEXT GP")
          .font(.system(size: 10, weight: .bold))
          .foregroundColor(F1WidgetStyle.brandRed)
          .tracking(0.8)

        Text(entry.raceName)
          .font(.system(size: 17, weight: .bold))
          .foregroundColor(.white)
          .lineLimit(1)
          .padding(.top, 6)

        if !entry.circuit.isEmpty {
          Text(entry.circuit)
            .font(.system(size: 11))
            .foregroundColor(F1WidgetStyle.muted)
            .lineLimit(1)
            .padding(.top, 2)
        }

        Spacer(minLength: 8)

        countdownBlock
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .padding(.leading, 16)
      .padding(.trailing, 10)
      .padding(.top, 14)
      .padding(.bottom, 14)
    }
  }

  @ViewBuilder
  private var countdownBlock: some View {
    if let target = entry.targetDate {
      if target <= Date() {
        Text("Session started")
          .font(.system(size: 11, weight: .semibold))
          .foregroundColor(F1WidgetStyle.brandRed)
      } else {
        let remaining = max(0, target.timeIntervalSinceNow)
        let days = Int(remaining) / 86_400
        let remAfterDays = remaining.truncatingRemainder(dividingBy: 86_400)
        let chronoEnd = Date().addingTimeInterval(remAfterDays)

        HStack(alignment: .top, spacing: 10) {
          VStack(spacing: 1) {
            Text(String(format: "%02d", days))
              .font(.system(size: 20, weight: .bold, design: .monospaced))
              .foregroundColor(.white)
            Text("DAYS")
              .font(.system(size: 9, weight: .medium))
              .foregroundColor(F1WidgetStyle.labelGray)
          }

          VStack(spacing: 1) {
            if #available(iOS 16.0, *) {
              Text(timerInterval: Date.now...chronoEnd, countsDown: true)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)
            } else {
              Text(legacyHms(remAfterDays))
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
            }
            Text("H : M : S")
              .font(.system(size: 9, weight: .medium))
              .foregroundColor(F1WidgetStyle.labelGray)
          }
          .frame(maxWidth: .infinity)
        }
      }
    }
  }

  private func legacyHms(_ remAfterDays: TimeInterval) -> String {
    let total = max(0, Int(remAfterDays))
    let hours = total / 3_600
    let minutes = (total % 3_600) / 60
    let seconds = total % 60
    return String(format: "%d:%02d:%02d", hours, minutes, seconds)
  }
}
