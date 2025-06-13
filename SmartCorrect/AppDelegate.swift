//
//  AppDelegate.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 09/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import AppKit
import Combine

class AppDelegate : NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var observer: NSObjectProtocol?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.servicesProvider = SmartCorrectServiceProvider()
        
        observer = NotificationCenter.default.addObserver(forName: Notification.smartCorrectServiceActivatedNotification, object: nil, queue: nil, using: { note in })
    }
}
