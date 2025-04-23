import WidgetKit
import SwiftUI
import Foundation

struct LetterEntry: TimelineEntry {
    let date: Date
    let letters: [Letter]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> LetterEntry {
        LetterEntry(date: Date(), letters: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (LetterEntry) -> Void) {
        let entry = fetchTodayLetters()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LetterEntry>) -> Void) {
        let entry = fetchTodayLetters()
        let timeline = Timeline(entries: [entry], policy: .after(Calendar.current.date(byAdding: .minute, value: 15, to: Date())!))
        completion(timeline)
    }

    func fetchTodayLetters() -> LetterEntry {
        let defaults = UserDefaults(suiteName: "group.com.yourname.thankgot") // App Group을 사용하여 데이터 공유
        let today = Calendar.current.startOfDay(for: Date())

        var todayLetters: [Letter] = []

        if let data = defaults?.data(forKey: "letters"),
           let allLetters = try? JSONDecoder().decode([Letter].self, from: data),
           let userData = defaults?.data(forKey: "currentUser"),
           let currentUser = try? JSONDecoder().decode(User.self, from: userData) {
            
            todayLetters = allLetters.filter {
                Calendar.current.isDate($0.date, inSameDayAs: today) &&
                $0.receiverUser == currentUser.nickname
            }
        }

        return LetterEntry(date: Date(), letters: todayLetters)
    }
}

struct LetterWidgetEntryView: View {
    var entry: LetterEntry

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("📬 오늘의 편지")
                    .font(.headline)
                Spacer()
                Link(destination: URL(string: "thankgot://addPage")!) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }

            if entry.letters.isEmpty {
                Text("오늘 받은 편지가 없어요!")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                ForEach(entry.letters.prefix(3)) { letter in
                    Text("• \(letter.content)")
                        .font(.caption)
                        .lineLimit(1)
                }
            }
        }
        .padding()
    }
}

@main
struct thankGotWidget: Widget {
    let kind: String = "LetterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LetterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("오늘의 편지")
        .description("오늘 받은 편지를 확인하세요.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
