//
//  SmartCorrectModelContainer.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 27/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftData

@MainActor
let promptContainer: ModelContainer = {
    do {
        let schema = Schema([
            Prompt.self,
        ])
#if DEBUG
        let memoryOnly = true
#else
        let memoryOnly = false
#endif
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: memoryOnly)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        
        var promptFetchDescriptor = FetchDescriptor<Prompt>()
        promptFetchDescriptor.fetchLimit = 1
        
        guard try modelContainer.mainContext.fetch(promptFetchDescriptor).count == 0 else { return modelContainer }
        
        // Fill in the default data
        
        let mainPrompt = Prompt(text: Constants.defaultMainPrompt, name: String(localized: "Main Prompt"), shouldShowButton: false)
        
        let secondaryPrompt = Prompt(text: Constants.defaultSecondaryPrompt, name: String(localized: "Secondary Prompt"), shouldShowButton: false)
        
        modelContainer.mainContext.insert(mainPrompt)
        modelContainer.mainContext.insert(secondaryPrompt)
        
        return modelContainer
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
    
}()


