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
    //@Environment(\.modelContext) private var modelContext
    @FocusState private var isFocused: Bool
    
    @Bindable var prompt: Prompt
    
    var body: some View {
        Form {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    TextField("Name of Shortcut", text: $prompt.name)
                    //TODO: KeyboardShortcuts.Recorder("Record Shortcut", name: KeyboardShortcuts.Name(name))
                    KeyboardShortcuts.Recorder(for: KeyboardShortcuts.Name(prompt.name))
                        .focused($isFocused)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Prompt for Shortcut")
                    TextEditor(text: $prompt.text)
                }
            }
        }
//        .onAppear {
//            if let prompt {
//                text = prompt.text
//                shortcut = prompt.shortcut
//                name = prompt.name
//            }
//        }
    }
}
