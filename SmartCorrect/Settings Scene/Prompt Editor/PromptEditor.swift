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
        HStack(alignment: .top, spacing: 16) {
            // Left side: Name and Shortcut
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Name")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("Shortcut name", text: $prompt.name)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 200)
                        .onSubmit {
                            saveChanges()
                        }
                        .accessibilityLabel("Shortcut name")
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Shortcut")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    KeyboardShortcuts.Recorder(for: KeyboardShortcuts.Name(prompt.name))
                        .frame(maxWidth: 200)
                        .accessibilityLabel("Record keyboard shortcut")
                }
            }
            .frame(maxWidth: 220)
            
            // Right side: Prompt text
            VStack(alignment: .leading, spacing: 4) {
                Text("Prompt Text")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                TextEditor(text: $prompt.text)
                    .focused($isTextEditorFocused)
                    .frame(minHeight: 80)
                    .scrollContentBackground(.hidden)
                    .background(Color(NSColor.textBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    )
                    .onChange(of: isTextEditorFocused) { oldValue, newValue in
                        if oldValue && !newValue {
                            saveChanges()
                        }
                    }
                    .accessibilityLabel("Prompt text editor")
            }
        }
        .padding()
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
