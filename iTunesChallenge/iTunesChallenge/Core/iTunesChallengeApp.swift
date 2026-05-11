//
//  iTunesChallengeApp.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 09/05/26.
//

import SwiftUI
import SwiftData

@main
struct iTunesChallengeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CachedSong.self,
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
            AppNavigationView()
                .modelContainer(sharedModelContainer)
        }
    }
}
