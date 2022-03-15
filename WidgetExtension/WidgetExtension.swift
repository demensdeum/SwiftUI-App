//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by ILIYA on 23.10.2021.
//

import WidgetKit
import SwiftUI
import Intents
import AppUI

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        debugPrint("placeholder(in)")
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        debugPrint("getSnapshot(for)")
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        debugPrint("getTimeline(for)")
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .minute, value: 0, to: currentDate)!
        let entry = SimpleEntry(
            date: entryDate,
            configuration: configuration
        )
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
    var text: String {
        let userDefaults = UserDefaults(
            suiteName: "group.com.demensdeum.swiftuiapp"
        )
        let moreThanThreeSymbolsSuffixesInfo = userDefaults?.string(
            forKey: "moreThanThreeSymbolsSuffixesInfo"
        ) ?? ""
        return moreThanThreeSymbolsSuffixesInfo
    }
}

struct WidgetExtensionEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            HStack {
                Text(entry.text)
            }
            .padding()
            HStack{
                Link(destination: URL(string: "app:///\(TabsScreenTabs.API.rawValue)")!, label: {
                    Text("API")
                        .foregroundColor(Color.white)
                })
                    .background(Color.gray)
                Spacer()
                Link(destination: URL(string: "app:///\(TabsScreenTabs.customNavigation.rawValue)")!, label: {
                    Text("Custom Navigation")
                        .foregroundColor(Color.white)
                })
                    .background(Color.gray)
                Spacer()
                Link(destination: URL(string: "app:///\(TabsScreenTabs.textInput.rawValue)")!, label: {
                    Text("Text Input")
                        .foregroundColor(Color.white)
                })
                    .background(Color.gray)
            }
            .padding()
        }
    }
}

@main
struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            WidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        WidgetExtensionEntryView(
            entry: SimpleEntry(
                date: Date(),
                configuration: ConfigurationIntent()
            )
        )
            .previewContext(
                WidgetPreviewContext(
                    family: .systemMedium
                )
            )
    }
}
