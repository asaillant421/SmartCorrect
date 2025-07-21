//
//  SmartCorrectServiceProvider.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 09/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import AppKit
import SwiftUI

class SmartCorrectServiceProvider : NSObject {
    private let openCorrectionWindow: (String) -> Void
    private var changeCount: Int
    private weak var pasteboard = NSPasteboard.general
    
    init(pasteboard: NSPasteboard = .general, openCorrectionWindow: @escaping (String) -> Void) {
        self.pasteboard = pasteboard
        self.changeCount = pasteboard.changeCount
        self.openCorrectionWindow = openCorrectionWindow
        super.init()
    }
    
    
    @objc func requestCorrection(
        _ pasteboard: NSPasteboard,
        userData: String?,
        error: AutoreleasingUnsafeMutablePointer<NSString>
    ) {
        print("Request correction [\(changeCount)/\(pasteboard.changeCount)]for: \(pasteboard.string(forType: .string) ?? userData ?? "<empty>")")
        guard let string = pasteboard.string(
            forType: NSPasteboard.PasteboardType.string
        ) else {
            return
        }
        
        
        
//        pasteboard.clearContents()
//        pasteboard.setString(
//            String(string.reversed()),
//            forType: .string
//        )
        
        openCorrectionWindow(string)
    }
    
    
}
