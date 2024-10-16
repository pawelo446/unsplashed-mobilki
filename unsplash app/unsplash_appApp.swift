//
//  unsplash_appApp.swift
//  unsplash app
//
//  Created by paweł maryniak on 16/10/2024.
//

import SwiftUI
import SwiftData

@main
struct unsplash_appApp: App {
    var sharedModelContainer: ModelContainer = {
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

    var body: some Scene {
        WindowGroup {
            SearchView()
        }
        .modelContainer(sharedModelContainer)
    }
}
