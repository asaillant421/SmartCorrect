//
//  SmartCorrectApp.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 08/06/2025.
//

import SwiftUI
import SwiftData
import Combine

@main
struct SmartCorrectApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.openSettings) private var openSettings
    @Environment(\.openWindow) private var openWindow
//    @State private var viewModel = CorrectionViewModel()
    
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
        WindowGroup(id: WindowIdentifier.smartCorrect.rawValue, for: String.self) { $text in
            CorrectionView(textForCorrection: text ?? "")
        }
        .modelContainer(sharedModelContainer)
        
        Settings {
            SettingsView()
        }
        .windowResizability(.contentMinSize)
        
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
