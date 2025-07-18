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
    //    override var canBecomeKey: Bool {
    //        return true
    //    }
    //
    //    override var canBecomeMain: Bool {
    //        return false
    //    }
    
    init(contentRect: NSRect, contentView: NSView) {
        super.init(contentRect: contentRect,
                   styleMask: [.nonactivatingPanel, .borderless],
                   backing: .buffered,
                   defer: false)
        
        level = .floating
        isMovableByWindowBackground = true

//        self.isOpaque = false
        //self.backgroundColor = .clear
        backgroundColor = .systemYellow // .systemGray
        
        hasShadow = true
        hidesOnDeactivate = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        ignoresMouseEvents = false
        title = ""
        isReleasedWhenClosed = false

        self.contentView = contentView
    }
}
