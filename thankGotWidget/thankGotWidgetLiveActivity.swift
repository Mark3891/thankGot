//
//  thankGotWidgetLiveActivity.swift
//  thankGotWidget
//
//  Created by Woody on 4/22/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct thankGotWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct thankGotWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: thankGotWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension thankGotWidgetAttributes {
    fileprivate static var preview: thankGotWidgetAttributes {
        thankGotWidgetAttributes(name: "World")
    }
}

extension thankGotWidgetAttributes.ContentState {
    fileprivate static var smiley: thankGotWidgetAttributes.ContentState {
        thankGotWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: thankGotWidgetAttributes.ContentState {
         thankGotWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: thankGotWidgetAttributes.preview) {
   thankGotWidgetLiveActivity()
} contentStates: {
    thankGotWidgetAttributes.ContentState.smiley
    thankGotWidgetAttributes.ContentState.starEyes
}
