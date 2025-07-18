//
//  TextSelectionService.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 07/07/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import ApplicationServices
import AppKit

actor TextSelectionService {
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
        
        let bundleID: String
        do {
            bundleID = try await findFrontmostBundleID()
        } catch {
            return
        }
        
        if await replaceSelectedTextViaAppleScript(with: newText, bundleID: bundleID) {
            return
        }
        
        await replaceSelectedTextViaSimulatedPaste(with: newText, bundleID: bundleID)
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
        print("Replacing via Accessibility: \(newText)")
        guard let axFocusedElement = findFocusedAXUIElement() else {
            print("Nothing focused in replaceSelectedTextViaAccessibility")
            return false
        }
        
        let result = AXUIElementSetAttributeValue(axFocusedElement, kAXSelectedTextAttribute as CFString, newText as CFTypeRef)
        
        print("Accessibility replacement result: \(result)")
        
        return .success == result
    }
    
    private func selectedTextViaAppleScript(bundleID: String) async -> String? {
        nil
    }
    
    private func replaceSelectedTextViaAppleScript(with newText: String, bundleID: String) async -> Bool {
        false
    }
    
    private func selectedTextViaSimulatedCopy(bundleID: String) async -> String? {
        guard let src = CGEventSource(stateID: .hidSystemState),
              let cDown = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: true),
              let cUp = CGEvent(keyboardEventSource: src, virtualKey: 0x08, keyDown: false)
        else { return nil }
        
         // 'c' key
        cDown.flags = .maskCommand
        cUp.flags = .maskCommand
        
        cDown.post(tap: .cghidEventTap)
        cUp.post(tap: .cghidEventTap)
        
        // Small delay for clipboard to update
        usleep(200_000)
        
        let pasteboard = NSPasteboard.general
        guard let copiedText = pasteboard.string(forType: .string) else {
            print("No text on clipboard.")
            return nil
        }
        
        return copiedText
    }
    
    @discardableResult
    private func replaceSelectedTextViaSimulatedPaste(with newText: String, bundleID: String) async -> Bool {
        guard let src = CGEventSource(stateID: .hidSystemState) else { return false }
        
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(newText, forType: .string)
        
        let vDown = CGEvent(keyboardEventSource: src, virtualKey: 0x09, keyDown: true) // 'v'
        vDown?.flags = .maskCommand
        let vUp = CGEvent(keyboardEventSource: src, virtualKey: 0x09, keyDown: false)
        vUp?.flags = .maskCommand
        
        vDown?.post(tap: .cghidEventTap)
        vUp?.post(tap: .cghidEventTap)
        
        return true
        
        //        NSPasteboard.general.setString(self.correctedText, forType: .string)
        
        //        pasteboard.clearContents()
        //        pasteboard.setString(
        //            String(string.reversed()),
        //            forType: .string
        //        )
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
