//
//  AppDelegate.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 09/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import AppKit

class AppDelegate : NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.servicesProvider = SmartCorrectServiceProvider()
    }
}
