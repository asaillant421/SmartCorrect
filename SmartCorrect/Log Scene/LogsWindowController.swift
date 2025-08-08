//
//  LogsWindowController.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 08/08/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Cocoa
import SwiftUI

class LogsWindowController: NSWindowController {
    private static var shared: LogsWindowController?
    
    static func showLogs() {
        if let existingController = shared {
            existingController.showWindow(nil)
            existingController.window?.makeKeyAndOrderFront(nil)
        } else {
            let controller = LogsWindowController()
            shared = controller
            controller.showWindow(nil)
        }
    }
    
    init() {
        let hostingView = NSHostingView(rootView: CorrectionLogsView().modelContainer(promptContainer))
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Correction Logs"
        window.contentView = hostingView
        window.center()
        window.setFrameAutosaveName("LogsWindow")
        
        super.init(window: window)
        
        // Clear static reference when window closes
        window.delegate = WindowDelegate { [weak self] in
            if self === LogsWindowController.shared {
                LogsWindowController.shared = nil
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class WindowDelegate: NSObject, NSWindowDelegate {
    let onClose: () -> Void
    
    init(onClose: @escaping () -> Void) {
        self.onClose = onClose
        super.init()
    }
    
    func windowWillClose(_ notification: Notification) {
        onClose()
    }
}