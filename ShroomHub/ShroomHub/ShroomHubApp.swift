//
//  ShroomHubApp.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 25.02.2025.
//

import SwiftUI
import SwiftData
import FirebaseAuthPackage

@main
struct ShroomHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
            ContentView(authenticationManager: authenticationManager)
                .environmentObject(AppSession())
        }
        .modelContainer(sharedModelContainer)
    }
}

// MARK: - Dependencies
private extension ShroomHubApp {
    private var authenticationManager: FirebaseAuthenticator {
        FirebaseAuthenticator()
    }
}
