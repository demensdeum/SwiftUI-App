//
//  SwiftUI_AppApp.swift
//  SwiftUI-WatchOS WatchKit Extension
//
//  Created by ILIYA on 06.01.2022.
//

import SwiftUI

@main
struct SwiftUI_AppApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
