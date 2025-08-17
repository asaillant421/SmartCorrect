//
//  ShortcutsAndPromptsSettingsView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 11/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import SwiftData

struct ShortcutsAndPromptsSettingsView : View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Prompt.creationDate) var prompts: [Prompt]
    
    var body: some View {
        VStack {
            List(prompts) { prompt in
                PromptEditor(prompt: prompt)
            }
        
            HStack {
                Spacer()
                Button("Add Prompt", systemImage: "plus") {
                    let newPrompt = Prompt()
                    modelContext.insert(newPrompt)
                }
            }

        }
        .padding(8)
    }
}
