//
//  SmartCorrectServiceProvider.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 09/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import AppKit

class SmartCorrectServiceProvider : NSObject {
    @objc func requestCorrection(
        _ pasteboard: NSPasteboard,
        userData: String?,
        error: AutoreleasingUnsafeMutablePointer<NSString>
    ) {
        print("Request correction for: \(pasteboard.string(forType: .string) ?? userData ?? "<empty>")")
        guard let string = pasteboard.string(
            forType: NSPasteboard.PasteboardType.string
        ) else {
            return
        }
        pasteboard.clearContents()
        pasteboard.setString(
            String(string.reversed()),
            forType: .string
        )
    }
}
