//
//  ClipboardService.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 07/07/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import ApplicationServices
import AppKit

actor ClipboardService {
//    static let shared = ClipboardService()
//    
//    private  init() {
//        super.init()
//    }
    
    func findSelectedText() async -> String? {
        if let text = await selectedTextViaAccessibility() {
            return text
        }
        
        let bundleID: String
        do {
            bundleID = try await findFrontmostBundleID()
        } catch {
            return nil
        }
        
        if let text = await selectedTextViaAppleScript(bundleID: bundleID) {
            return text
        }
        
        if let text =  await selectedTextViaSimulatedCopy(bundleID: bundleID) {
            return text
        }
        
        return nil
    }
    
    func replaceSelectedText(with newText: String) async {
        
        if await replaceSelectedTextViaAccessibility(with: newText) {
            return
        }
        
        // Find foremost application
        
        
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(newText, forType: .string)
        //        NSPasteboard.general.setString(self.correctedText, forType: .string)
        
        //        pasteboard.clearContents()
        //        pasteboard.setString(
        //            String(string.reversed()),
        //            forType: .string
        //        )
    }
    
    private func selectedTextViaAccessibility() async -> String? {
        guard let axFocusedElement = findFocusedAXUIElement() else {
            return nil
        }
        
        var selectedTextValue: AnyObject?
        let result = AXUIElementCopyAttributeValue(axFocusedElement, kAXSelectedTextAttribute as CFString, &selectedTextValue)
        
        guard result == .success, let selectedText = selectedTextValue as? String else {
            return nil
        }

        return selectedText
    }
    
    private func replaceSelectedTextViaAccessibility(with newText: String) async -> Bool {
        guard let axFocusedElement = findFocusedAXUIElement() else {
            return false
        }
        
        let result = AXUIElementSetAttributeValue(axFocusedElement, kAXSelectedTextAttribute as CFString, newText as CFTypeRef)
        
        return .success == result
    }
    
    private func selectedTextViaAppleScript(bundleID: String) async -> String? {
        nil
    }
    
    private func replaceSelectedTextViaAppleScript(with newText: String, bundleID: String) async -> Bool {
        true
    }
    
    private func selectedTextViaSimulatedCopy(bundleID: String) async -> String? {
        nil
    }
    
    private func replaceSelectedTextViaSimulatedPaste(with newText: String, bundleID: String) async -> Bool {
        true
    }
    
    private func findFrontmostBundleID() async throws -> String {
        let systemWideElement = AXUIElementCreateSystemWide()
        
        var focusedApp: AnyObject?
        let result = AXUIElementCopyAttributeValue(systemWideElement,
                                                   kAXFocusedApplicationAttribute as CFString,
                                                   &focusedApp)
        
        let fallback: String =
            NSWorkspace.shared.frontmostApplication?.bundleIdentifier ?? ""
        
        guard result == .success, let focusedApp else {
            // chrome or vscode will return AXError(-25212)
            return fallback
        }
        
        let axFocusedApp = focusedApp as! AXUIElement
        
        guard let focusedPid = axFocusedApp.findPid() else {
            return fallback
        }
        
        let runningApp = NSRunningApplication(processIdentifier: focusedPid)
        return runningApp?.bundleIdentifier ?? ""
    }
    
    private func findFocusedAXUIElement() -> AXUIElement? {
        let systemWideElement: AXUIElement = AXUIElementCreateSystemWide()
        
        var focused: AnyObject?
        let result = AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedApplicationAttribute as CFString, &focused)
        
        guard result == .success, let focused else {
            return nil
        }
        
        let axFocusedElement = focused as! AXUIElement
        
        return axFocusedElement
    }
}
