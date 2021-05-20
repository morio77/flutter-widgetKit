//
//  counterView.swift
//  counterView
//
//  Created by 本多健也 on 2021/05/17.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    // WidgetKitが初めてレンダリングする時/特定のデータ保護資格の条件に合致したときに表示される
    // (ユーザデータとは関係ない、デフォルト値を設定することが多い)
    // https://developer.apple.com/documentation/widgetkit/timelineprovider/placeholder(in:)-6ypjs
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), counter: 0, configuration: ConfigurationIntent())
    }

    // ウィジェットギャラリーに表示される
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        // AppGroupのUserDefaultからカウンターの値を取得
        let userDefaults = UserDefaults(suiteName: "group.counter.hondakenya.sample")
        let counter = userDefaults?.value(forKey: "counter") as? Int
        
        let entry = SimpleEntry(date: Date(), counter: counter ?? 0, configuration: configuration)
        completion(entry)
    }

    // 実際のウィジェットに表示される
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        // AppGroupのUserDefaultからカウンターの値を取得
        let userDefaults = UserDefaults(suiteName: "group.counter.hondakenya.sample")
        let counter = userDefaults?.integer(forKey: "counter") ?? 0
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, counter: counter, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let counter: Int
    let configuration: ConfigurationIntent
}

struct counterViewEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(String(entry.counter)).font(.system(size: 100))
    }
}

@main
struct counterView: Widget {
    let kind: String = "counterView"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            counterViewEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct counterView_Previews: PreviewProvider {
    static var previews: some View {
        counterViewEntryView(entry: SimpleEntry(date: Date(), counter: 0, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
