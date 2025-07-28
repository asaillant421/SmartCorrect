//
//  PromptEditor.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 22/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import SwiftData
import KeyboardShortcuts

struct PromptEditor: View {
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isTextEditorFocused: Bool
    
    @Bindable var prompt: Prompt
    
    var body: some View {
        Form {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    TextField("Name of Shortcut", text: $prompt.name)
                        .onSubmit {
                            saveChanges()
                        }
                    //TODO: KeyboardShortcuts.Recorder("Record Shortcut", name: KeyboardShortcuts.Name(name))
                    KeyboardShortcuts.Recorder(for: KeyboardShortcuts.Name(prompt.name))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Prompt for Shortcut")
                    TextEditor(text: $prompt.text)
                        .focused($isTextEditorFocused)
                        .onChange(of: isTextEditorFocused) { oldValue, newValue in
                            // Save when TextEditor loses focus
                            if oldValue && !newValue {
                                saveChanges()
                            }
                        }
                }
            }
        }
        .onChange(of: prompt.name) { oldValue, newValue in
            // Also save when name changes (with debouncing)
            if oldValue != newValue {
                saveChanges()
            }
        }
        .onChange(of: prompt.text) { oldValue, newValue in
            // Save when text changes (with debouncing)
            if oldValue != newValue {
                saveChangesWithDebounce()
            }
        }
    }
    
    private func saveChanges() {
        do {
            try modelContext.save()
            print("Prompt saved: '\(prompt.name)'")
        } catch {
            print("Failed to save prompt: \(error)")
        }
    }
    
    @State private var saveTask: Task<Void, Never>?
    
    private func saveChangesWithDebounce() {
        // Cancel previous save task
        saveTask?.cancel()
        
        // Create new debounced save task
        saveTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 500ms delay
            
            if !Task.isCancelled {
                await MainActor.run {
                    saveChanges()
                }
            }
        }
    }
}
