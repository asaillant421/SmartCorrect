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
    private var overlayController: OverlayWindowController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        overlayController = OverlayWindowController {
            ContentView()
        }
        
        GlobalHotKeyManager.registerHotKey {
            self.overlayController?.toggle()
        }
    }
    
    
}
