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
    @Query var prompts: [Prompt]
    @Environment(\.modelContext) var modelContext
    @State private var selection: PersistentIdentifier?
    
    var body: some View {
        VStack {
            List(prompts) { prompt in
                PromptEditor(prompt: prompt)
            }
        
            HStack {
                Button("Add Prompt", systemImage: "plus") {
                    let newPrompt = Prompt()
                    modelContext.insert(newPrompt)
                    selection = newPrompt.id
                }
            }

        }
        .padding(8)
        
        
        
//        ScrollView {
//            VStack(alignment: .leading) {
//                
//            }
//        }
    }
}
