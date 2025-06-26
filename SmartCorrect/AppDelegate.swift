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

class AppDelegate : NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var observer: NSObjectProtocol?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.servicesProvider = SmartCorrectServiceProvider(openCorrectionWindow: openCorrectionWindow)
    }
    
    private func openCorrectionWindow(text: String) {
        let notification = Notification(name: Notification.serviceActivated, object: nil, userInfo: [Notification.selectedTextKey:text])
        NotificationCenter.default.post(notification)
        
        NSApplication.shared.activate(windowIdentifier: .smartCorrect, sender: self)
    }
}
