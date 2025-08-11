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
    private var previousBundleID: String?
    private var previousAXUIElement: AXUIElement?
    
    var selectedTextSource: String? {
        guard let bundleID = previousBundleID, !bundleID.isEmpty else { return nil
        }
        
        return NSRunningApplication.runningApplications(withBundleIdentifier: bundleID).first?.localizedName
    }
    
    func getBundleID() async -> String? {
        return previousBundleID
    }
    
    func findSelectedText() async -> String? {
        if let text = await selectedTextViaAccessibility() {
            print("Found \(text) via Accessibility")
            return text
        }
        
        let bundleID: String
        do {
            bundleID = try await findFrontmostBundleID()
            print("Found frontmost app has bundle ID: \(bundleID)")
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
        print("Attempting to replace text via AppleScript for bundleID: \(bundleID)")
        
        // Escape newText for AppleScript
        let escapedText = newText.replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\t", with: "\\t")
        
        let script: String
        
        // Handle specific applications
        switch bundleID {
        case "com.microsoft.Word":
            script = """
                tell application "Microsoft Word"
                    if (count of documents) > 0 then
                        tell active document
                            set content of text object of selection to "\(escapedText)"
                        end tell
                        return true
                    end if
                end tell
                return false
            """
            
        case "com.apple.TextEdit":
            script = """
                tell application "TextEdit"
                    if (count of documents) > 0 then
                        tell front document
                            set text of selection to "\(escapedText)"
                        end tell
                        return true
                    end if
                end tell
                return false
            """
            
        case "com.apple.Notes":
            // Notes can't modify the selection via AppleScript
            return false
//            script = """
//                tell application "Notes"
//                    tell first note of selection
//                        set text of body to "\(escapedText)"
//                    end tell
//                    return true
//                end tell
//                return false
//            """
            
        case "com.apple.mail":
            script = """
                tell application "Mail"
                    tell front window
                        set content of selection to "\(escapedText)"
                    end tell
                    return true
                end tell
                return false
            """
            
        default:
            // Generic AppleScript that works with many applications
            script = """
                tell application "System Events"
                    tell (first application process whose bundle identifier is "\(bundleID)")
                        if exists (first UI element whose focused is true) then
                            set focused of (first UI element whose focused is true) to true
                            keystroke "\(escapedText)"
                            return true
                        end if
                    end tell
                end tell
                return false
            """
        }
        
        return await executeAppleScript(script)
    }
    
    private func executeAppleScript(_ script: String) async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                var error: NSDictionary?
                let appleScript = NSAppleScript(source: script)
                let result = appleScript?.executeAndReturnError(&error)
                
                if let error {
                    print("AppleScript error: \(error)")
                    continuation.resume(returning: false)
                } else if let result {
                    let success = result.booleanValue
                    continuation.resume(returning: success)
                } else {
                    continuation.resume(returning: false)
                }
            }
        }
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
        print("replaceSelectedTextViaSimulatedPaste:\(newText) into:\(bundleID)")
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                // Save current clipboard content
                let originalClipboard = NSPasteboard.general.string(forType: .string)
                
                // Set new text to clipboard
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                guard pasteboard.setString(newText, forType: .string) else {
                    print("Failed to set clipboard content")
                    continuation.resume(returning: false)
                    return
                }
                
                // Small delay to ensure clipboard is updated
                usleep(50_000) // 50ms
                
                // Verify clipboard was set correctly
                guard pasteboard.string(forType: .string) == newText else {
                    print("Clipboard content doesn't match expected text")
                    continuation.resume(returning: false)
                    return
                }
                
                // Create event source
                guard let eventSource = CGEventSource(stateID: .hidSystemState) else {
                    print("Failed to create event source")
                    continuation.resume(returning: false)
                    return
                }
                
                // Find the target app's process ID for targeting events
                var targetPid: pid_t = 0
                if let runningApp = NSWorkspace.shared.runningApplications.first(where: { $0.bundleIdentifier == bundleID }) {
                    targetPid = runningApp.processIdentifier
                }
                
                // Create Cmd+V key events
                guard let vKeyDown = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x09, keyDown: true),
                      let vKeyUp = CGEvent(keyboardEventSource: eventSource, virtualKey: 0x09, keyDown: false) else {
                    print("Failed to create keyboard events")
                    continuation.resume(returning: false)
                    return
                }
                
                // Set Command modifier
                vKeyDown.flags = .maskCommand
                vKeyUp.flags = .maskCommand
                
                // Target specific application if we found its PID
                if targetPid != 0 {
                    vKeyDown.setIntegerValueField(.eventTargetUnixProcessID, value: Int64(targetPid))
                    vKeyUp.setIntegerValueField(.eventTargetUnixProcessID, value: Int64(targetPid))
                }
                
                // Post the events
                let location = CGEventTapLocation.cghidEventTap
                vKeyDown.post(tap: location)
                
                // Small delay between key down and up
                usleep(10_000) // 10ms
                
                vKeyUp.post(tap: location)
                
                // Small delay to allow paste to complete
                usleep(100_000) // 100ms
                
                // Restore original clipboard if it existed
                if let originalClipboard {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        pasteboard.clearContents()
                        pasteboard.setString(originalClipboard, forType: .string)
                    }
                }
                
                print("Simulated paste completed for bundleID: \(bundleID)")
                continuation.resume(returning: true)
            }
        }
    }
    
    private func findFrontmostBundleID() async throws -> String {
        let smartCorrectBundleID = Bundle.main.bundleIdentifier
        
        let getFallbackBundleID = {
            let allApps = NSWorkspace.shared.runningApplications
                .filter { $0.activationPolicy == .regular }
                .filter { $0.bundleIdentifier != smartCorrectBundleID }
                .sorted { $0.launchDate ?? Date.distantPast > $1.launchDate ?? Date.distantPast }
            
            print("Falling back, previous is \(self.previousBundleID ?? "unknown")")
            
            return self.previousBundleID ?? allApps.first?.bundleIdentifier ?? ""
        }
        
        guard let axFocusedApp = findFocusedAXUIElement(),
                let focusedPid = axFocusedApp.findPid() else {
            return getFallbackBundleID()
        }
        
        let runningApp = NSRunningApplication(processIdentifier: focusedPid)
        let bundleID = runningApp?.bundleIdentifier ?? ""
        
        if bundleID == smartCorrectBundleID {
            return getFallbackBundleID()
        }
        
        previousBundleID = bundleID
        
        return bundleID
    }
    
    private func findFocusedAXUIElement() -> AXUIElement? {
        let systemWideElement: AXUIElement = AXUIElementCreateSystemWide()
        
        var focused: AnyObject?
        let result = AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedApplicationAttribute as CFString, &focused)
        
        guard result == .success, let focused else {
            return previousAXUIElement
        }
        
        let axFocusedElement = focused as! AXUIElement
        
        previousAXUIElement = axFocusedElement
        
        return axFocusedElement
    }
}
