//
//  art365App.swift
//  art365
//
//  Created by 土方希 on 2025/04/12.
//

import SwiftUI
import SwiftData

@main
struct art365App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
