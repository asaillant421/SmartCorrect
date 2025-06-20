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
    @State private var viewModel: CorrectionViewModel?
    @State private var shouldShowMainWindow = false
    
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
                    EmptyView()
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
        }
        .windowLevel(.floating)
        //.defaultLaunchBehavior(.suppressed)
        //.handlesExternalEvents(matching: ["*"])
        
        Settings {
            SettingsView()
                .frame(
                    minWidth: 400,
                    maxWidth: 800,
                    minHeight: 200,
                    maxHeight: 800
                )
        }
        .windowResizability(.contentSize)
        
        MenuBarExtra("SmartCorrect", systemImage: "wand.and.rays") {
            WindowVisibilityToggle(windowID: WindowIdentifier.smartCorrect.rawValue)
            Divider()
            Button("About") {
                NSApplication.shared.orderFrontStandardAboutPanel(nil)
            }
            Divider()
            Button("Settings...") {
                openSettings()
            }
            Divider()
            Button("Quit SmartCorrect") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
    }
    
    private func openMainWindow() {
        openWindow(id: WindowIdentifier.smartCorrect.rawValue)
        
        NSApplication.shared.activate(windowIdentifier: .smartCorrect)
    }

        //
        //        Window(Text("Flumpy"), id: WindowIdentifier.smartCorrect.rawValue) {
        //            Group {
        //                if let viewModel {
        //                    CorrectionView()
        //                        .environment(viewModel)
        //                } else {
        //                    EmptyView()
        //                }
        //            }
        //            .onAppear {
        //                if nil == viewModel, let apiKey, !apiKey.isEmpty {
        //                    viewModel = CorrectionViewModel(apiKey: apiKey)
        ////                } else {
        ////                    // Bring up settings for API key instead
        ////                    solicitAPIKey()
        //                }
        //            }
        //            .onDisappear {
        //                viewModel = nil
        //            }
        //        }
        //        .modelContainer(sharedModelContainer)
        
}
