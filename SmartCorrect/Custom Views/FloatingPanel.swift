//
//  FloatingPanel.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 17/07/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Cocoa
import SwiftUI

class FloatingPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
    
    
    override func orderFrontRegardless() {
        let n = Notification(name: .orderedFront)
        NotificationCenter.default.post(n)
        super.orderFrontRegardless()
    }
    
    init(contentRect: NSRect, contentView: NSView) {
        super.init(contentRect: contentRect,
                   styleMask: [.nonactivatingPanel, .borderless],
                   backing: .buffered,
                   defer: false)
        
        level = .floating
        isMovableByWindowBackground = true
        becomesKeyOnlyIfNeeded = true
        
        hasShadow = true
        hidesOnDeactivate = false
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        ignoresMouseEvents = false
        title = ""
        isReleasedWhenClosed = false

        self.contentView = contentView
    }
}
