//
//  ContentView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 17/07/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import Combine
import SwiftData

struct ContentView: View {
    @AppSecureStorage("apiKey") private var apiKey: String?
//    @Environment(\.openSettings) private var openSettings
//    @Environment(\.openWindow) private var openWindow
//    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: CorrectionViewModel?
    @State private var accessibilityPermitted = false
    private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        //Window(Text("SmartCorrect"), id: WindowIdentifier.smartCorrect.id) {
            Group {
                if nil != viewModel {
                    CorrectionView()
                        .simultaneousGesture(WindowDragGesture())
                    
                        .checkAccessibility(interval: 3, access: $accessibilityPermitted)
                } else {
                    EmptyView()
                }
            }
            .onAppear {
                if nil == viewModel, let apiKey, !apiKey.isEmpty {
                    let newViewModel = CorrectionViewModel(apiKey: apiKey, modelContext: modelContext)
                    viewModel = newViewModel
                    
                    // Set up the shortcut manager with the view model
                    PromptShortcutManager.shared.setCorrectionViewModel(newViewModel)
                }
            }
        //}
        .environment(viewModel)
        
//        Settings {
//            SettingsView()
//                .frame(
//                    minWidth: 400,
//                    maxWidth: 800,
//                    minHeight: 200,
//                    maxHeight: 800
//                )
//        }
//        .modelContainer(promptContainer)
//        .windowResizability(.contentSize)
//        
//        MenuBarExtra("SmartCorrect", systemImage: "wand.and.rays") {
//            Button("Open SmartCorrect") {
//                openMainWindow()
//            }
//            Divider()
//            Button("About") {
//                NSApplication.shared.orderFrontStandardAboutPanel(nil)
//            }
//            Divider()
//            Button("Settings...") {
//                openSettings()
//            }
//            Divider()
//            Button("Quit SmartCorrect") {
//                NSApplication.shared.terminate(nil)
//            }.keyboardShortcut("q")
//        }
    }
    
}
