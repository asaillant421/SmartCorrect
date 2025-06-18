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
    @AppSecureStorage("apiKey") private var apiKey: String?
    @Environment(\.openSettings) private var openSettings
    @Environment(\.openWindow) private var openWindow
    @State var viewModel: CorrectionViewModel?
    
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
        Window(Text("Flumpy"), id: WindowIdentifier.smartCorrect.rawValue) {
            Group {
                if let viewModel {
                    CorrectionView()
                        .environment(viewModel)
                } else {
                    Spacer()
                }
            }
            .onAppear {
                if nil == viewModel, let apiKey, !apiKey.isEmpty {
                    viewModel = CorrectionViewModel(apiKey: apiKey)
//                } else {
//                    // Bring up settings for API key instead
//                    solicitAPIKey()
                }
            }
            .onDisappear {
                viewModel = nil
            }
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
