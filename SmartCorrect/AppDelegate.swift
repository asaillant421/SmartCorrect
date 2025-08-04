//
//  AppDelegate.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 09/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import AppKit
import Combine
import SwiftUI
import SwiftData

extension Notification.Name {
    static let menuBarExtraToggled = Notification.Name("menuBarExtraToggled")
}

class AppDelegate : NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var overlayController: OverlayWindowController?
    private var settingsWindowController: NSWindowController?
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        overlayController = OverlayWindowController {
            ContentView()
                .modelContainer(promptContainer)
        }
        
        GlobalHotKeyManager.registerHotKey {
            self.overlayController?.toggle()
        }
        
        setupAppMode()
        
        // Listen for changes to the showMenuBarExtra setting
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(menuBarSettingChanged),
            name: .menuBarExtraToggled,
            object: nil
        )
    }
    
    private func setupAppMode() {
        if showMenuBarExtra {
            setupMenuBarMode()
        } else {
            setupDockMode()
        }
    }
    
    private func setupMenuBarMode() {
        // Set app as background-only (utility app)
        NSApp.setActivationPolicy(.accessory)
        
        // Create menu bar item if it doesn't exist
        if statusItem == nil {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            
            if let button = statusItem?.button {
                button.image = NSImage(systemSymbolName: "wand.and.rays", accessibilityDescription: "SmartCorrect")
                button.imagePosition = .imageOnly
            }
            
            let menu = NSMenu()
            
            let openItem = NSMenuItem(title: "Open SmartCorrect", action: #selector(openSmartCorrect), keyEquivalent: "")
            openItem.target = self
            menu.addItem(openItem)
            
            menu.addItem(NSMenuItem.separator())
            
            let aboutItem = NSMenuItem(title: "About", action: #selector(showAbout), keyEquivalent: "")
            aboutItem.target = self
            menu.addItem(aboutItem)
            
            menu.addItem(NSMenuItem.separator())
            
            let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: "")
            settingsItem.target = self
            menu.addItem(settingsItem)
            
            menu.addItem(NSMenuItem.separator())
            
            let quitItem = NSMenuItem(title: "Quit SmartCorrect", action: #selector(quitApp), keyEquivalent: "q")
            quitItem.target = self
            menu.addItem(quitItem)
            
            statusItem?.menu = menu
        }
    }
    
    private func setupDockMode() {
        // Set app as regular app (appears in dock)
        NSApp.setActivationPolicy(.regular)
        
        // Remove menu bar item
        if let statusItem = statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
            self.statusItem = nil
        }
        
        // Setup application menu for dock mode
        setupApplicationMenu()
    }
    
    private func setupApplicationMenu() {
        let mainMenu = NSMenu()
        
        // App menu
        let appMenuItem = NSMenuItem()
        let appMenu = NSMenu()
        
        let aboutItem = NSMenuItem(title: "About SmartCorrect", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        appMenu.addItem(aboutItem)
        
        appMenu.addItem(NSMenuItem.separator())
        
        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        appMenu.addItem(settingsItem)
        
        appMenu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit SmartCorrect", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        appMenu.addItem(quitItem)
        
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)
        
        // Window menu
        let windowMenuItem = NSMenuItem(title: "Window", action: nil, keyEquivalent: "")
        let windowMenu = NSMenu(title: "Window")
        windowMenuItem.submenu = windowMenu
        mainMenu.addItem(windowMenuItem)
        
        NSApp.windowsMenu = windowMenu
        NSApp.mainMenu = mainMenu
    }
    
    @objc private func menuBarSettingChanged() {
        // Check if showMenuBarExtra changed
        setupAppMode()
    }
    
    @objc private func openSmartCorrect() {
        overlayController?.toggle()
    }
    
    @objc private func showAbout() {
        NSApplication.shared.orderFrontStandardAboutPanel(nil)
    }
    
    @MainActor @objc private func openSettings() {
        if settingsWindowController == nil {
            let settingsView = SettingsView()
                .modelContainer(promptContainer)
            let hostingView = NSHostingView(rootView: settingsView)
            
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered,
                defer: false
            )
            
            window.title = "SmartCorrect Settings"
            window.contentView = hostingView
            window.center()
            window.setFrameAutosaveName("SettingsWindow")
            
            settingsWindowController = NSWindowController(window: window)
        }
        
        settingsWindowController?.showWindow(nil)
        settingsWindowController?.window?.makeKeyAndOrderFront(nil)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
