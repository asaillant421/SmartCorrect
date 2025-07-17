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
    @State private var accessibilityPermitted = false
    private var cancellables: Set<AnyCancellable> = []
    
    var body: some Scene {
        WindowGroup {
            DebugView()
        }
        
        Window(Text("SmartCorrect"), id: WindowIdentifier.smartCorrect.rawValue) {
            Group {
                if nil != viewModel {
                    CorrectionView()
                        .simultaneousGesture(WindowDragGesture())
                        .checkAccessibility(interval: 3, access: $accessibilityPermitted)
                        .toolbarVisibility(.hidden, for: .windowToolbar)
                        //.containerBackground(.clear, for: .window)
                } else {
                    EmptyView()
                }
            }
            .onAppear {
                if nil == viewModel, let apiKey, !apiKey.isEmpty {
                    viewModel = CorrectionViewModel(apiKey: apiKey)
                } else {
                    // Bring up settings for API key instead
                    openSettings()
                }
            }
        }
        .environment(viewModel)
//        .windowStyle(.plain)
        .modelContainer(promptContainer)
        .windowManagerRole(.principal)
        .windowLevel(.floating)
//        .windowResizability(.contentSize)
        .restorationBehavior(.automatic)
        
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
            Button("Open SmartCorrect") {
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
    
    init() {
        let cancellable = NotificationCenter.default.publisher(for: Notification.serviceActivated)
            .sink(receiveValue: handleNotification(note:))
        
        cancellables.insert(cancellable)
    }
    
    func openMainWindow() {
        openWindow(id: WindowIdentifier.smartCorrect.rawValue)
        
        NSApplication.shared.activate(windowIdentifier: .smartCorrect)
    }

    private func handleNotification(note: Notification) {
        guard Notification.serviceActivated == note.name else { return }
        
        openMainWindow()
    }
}
