//
//  NSApplicationExtensions.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 19/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import AppKit

extension NSApplication {
    func window(withIdentifier id: WindowIdentifier) -> NSWindow? {
        windows.first(where: { $0.identifier?.rawValue == id.rawValue})
    }
    
    func activate(windowIdentifier: WindowIdentifier, sender: NSObject? = nil) {
        activate()
        
        guard let w = window(withIdentifier: windowIdentifier) else { return }
        
        w.makeMain()
        w.makeKeyAndOrderFront(sender)
    }
}
