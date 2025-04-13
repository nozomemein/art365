//
//  Schema.swift
//  art365
//
//  Created by 土方希 on 2025/04/13.
//

import SwiftData

let sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Item.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

