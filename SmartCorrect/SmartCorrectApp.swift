//
//  SmartCorrectApp.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 08/06/2025.
//

//import SwiftUI
//import SwiftData
//import Combine
//
//@main
//struct SmartCorrectApp: App {
//    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    @AppSecureStorage("apiKey") private var apiKey: String?
//    @Environment(\.openSettings) private var openSettings
//    @Environment(\.openWindow) private var openWindow
//    @State private var viewModel: CorrectionViewModel?
//    @State private var accessibilityPermitted = false
//    private var cancellables: Set<AnyCancellable> = []
//    
//    var body: some Scene {
//        
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
//                //openMainWindow()
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
//    }
//    
////    init() {
////        let cancellable = NotificationCenter.default.publisher(for: .serviceActivated)
////            .sink(receiveValue: handleNotification(note:))
////        
////        cancellables.insert(cancellable)
////    }
////    
////    func openMainWindow() {
////        openWindow(id: WindowIdentifier.smartCorrect.rawValue)
////        
////        NSApplication.shared.activate(windowIdentifier: .smartCorrect)
////    }
////
////    private func handleNotification(note: Notification) {
////        guard .serviceActivated == note.name else { return }
////        
////        openMainWindow()
////    }
//}
