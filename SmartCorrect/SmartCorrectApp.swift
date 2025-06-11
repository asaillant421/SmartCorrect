//
//  SmartCorrectApp.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 08/06/2025.
//

import SwiftUI
import SwiftData

@main
struct SmartCorrectApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.openSettings) private var openSettings
    
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        .windowResizability(.contentMinSize)
        #endif
        
        MenuBarExtra("SmartCorrect", systemImage: "wand.and.rays") {
            Button("About") {
                NSApplication.shared.orderFrontStandardAboutPanel(nil)
            }
            Divider()
            Button("Settings...") {
                openSettings()
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
    }
}
