//
//  PromptShortcutManager.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 08/08/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation
import KeyboardShortcuts
import SwiftData

@MainActor
class PromptShortcutManager: ObservableObject {
    static let shared = PromptShortcutManager()
    
    private var registeredShortcuts: [String: KeyboardShortcuts.Name] = [:]
    private var correctionViewModel: CorrectionViewModel?
    private var overlayController: OverlayWindowController?
    
    private init() {}
    
    func setCorrectionViewModel(_ viewModel: CorrectionViewModel) {
        self.correctionViewModel = viewModel
    }
    
    func setOverlayController(_ controller: OverlayWindowController) {
        self.overlayController = controller
    }
    
    func setupMainShortcut(with context: ModelContext) {
        // Find the main prompt (shouldShowButton == false)
        var descriptor = FetchDescriptor<Prompt>()
        descriptor.predicate = #Predicate<Prompt> { $0.shouldShowButton == false }
        descriptor.fetchLimit = 1
        
        do {
            guard let mainPrompt = try context.fetch(descriptor).first,
                    let mainShortcutName = registerShortcut(for: mainPrompt) else { return } // Return if failed to register
            
            if nil == KeyboardShortcuts.getShortcut(for: mainShortcutName) {
                // Set up the default main shortcut with Cmd+Opt+;
                KeyboardShortcuts.setShortcut(.init(.semicolon, modifiers: [.command, .option]), for: mainShortcutName)
            }
            
            print("Set up main shortcut (Cmd+Opt+;) for main prompt")
            
        } catch {
            print("Failed to find main prompt: \(error)")
        }
    }
    
    func loadExistingPrompts(from context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<Prompt>()
            let prompts = try context.fetch(descriptor)
            
            for prompt in prompts where !prompt.name.isEmpty {
                registerShortcut(for: prompt)
            }
            
            print("Loaded \(prompts.count) existing prompts with shortcuts")
        } catch {
            print("Failed to load existing prompts: \(error)")
        }
    }
    
    @discardableResult
    func registerShortcut(for prompt: Prompt) -> KeyboardShortcuts.Name? {
        guard !prompt.name.isEmpty else { return nil }
        
        // Create a unique shortcut name based on the prompt ID/name
        let shortcutName = KeyboardShortcuts.Name("prompt_\(prompt.name)")
        
        // Store the mapping
        registeredShortcuts[prompt.name] = shortcutName
        
        // Set up the shortcut action
        KeyboardShortcuts.onKeyUp(for: shortcutName) { [weak self] in
            Task { @MainActor in
                await self?.executePrompt(prompt)
            }
        }
        
        print("Registered shortcut for prompt: \(prompt.name)")
        
        return shortcutName
    }
    
    func unregisterShortcut(for promptName: String) {
        if let shortcutName = registeredShortcuts[promptName] {
            KeyboardShortcuts.reset(shortcutName)
            registeredShortcuts.removeValue(forKey: promptName)
            print("Unregistered shortcut for prompt: \(promptName)")
        }
    }
    
    func getShortcutName(for prompt: Prompt) -> KeyboardShortcuts.Name? {
        guard !prompt.name.isEmpty else { return nil }
        
        let shortcutName = KeyboardShortcuts.Name("prompt_\(prompt.name)")
        registeredShortcuts[prompt.name] = shortcutName
        return shortcutName
    }
        
    private func executePrompt(_ prompt: Prompt) async {
        // Show the overlay controller for custom prompts too
        overlayController?.show()
        
        guard let viewModel = correctionViewModel else {
            print("No correction view model available")
            return
        }
        
        print("Executing prompt: \(prompt.name) with text: \(prompt.text)")
        
        // First, get the selected text
        await viewModel.findSelectedText()
        
        // If there's text selected, correct it using the prompt
        if !viewModel.textForCorrection.isEmpty {
            do {
                try await viewModel.correctText(prompt: prompt.text)
            } catch {
                print("Failed to execute prompt: \(error)")
            }
        }
    }
}
