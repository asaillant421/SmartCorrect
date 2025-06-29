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
    
    var body: some Scene {
        Window(Text("SmartCorrect"), id: WindowIdentifier.smartCorrect.rawValue) {
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
        .modelContainer(promptContainer)
        .windowManagerRole(.principal)
        .windowLevel(.normal)
        .restorationBehavior(.automatic)
        
        
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
        .modelContainer(promptContainer)
        .windowResizability(.contentSize)
        
        MenuBarExtra("SmartCorrect", systemImage: "wand.and.rays") {
            Button("Improve Text") {
                openMainWindow()
            }
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
