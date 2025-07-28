//
//  CorrectionViewModel.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 13/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import Combine

@Observable
class CorrectionViewModel {
    var shouldSaveAdditionalInstructions = false
    private let apiKey: String
    
    var textForCorrection = ""
    var correctedText = ""
    var additionalInstructions = ""
    
    private let service: CorrectionService
    private let textService = TextSelectionService()
    
    init(apiKey: String) {
        self.apiKey = apiKey
        service = CorrectionService(apiKey: apiKey)
    }
    
    func findSelectedText() async {
        guard let text = await textService.findSelectedText(), text != textForCorrection else { return }
        
        print("New text is \(text)")
        textForCorrection = text
        correctedText = ""
    }
    
//    func correctText() async throws {
//        if additionalInstructions.isEmpty {
//            correctedText = try await service.fetchCorrection(for: textForCorrection)
//        } else {
//            try await improveCorrection(withModifications: additionalInstructions)
//        }
//    }
    
    func correctText(prompt: String) async throws {
        correctedText = try await service.fetchCorrection(for: textForCorrection, prompt: prompt)
    }
    
    func pasteCorrection() async {
        
        await textService.replaceSelectedText(with: correctedText)
    }
    
    func improveCorrection(withModifications extraInstructions: String? = nil) async throws {
//        let additional = extraInstructions ?? additionalInstructions
//        
//        let modifiedPrompt = Constants.defaultSecondaryPrompt.replacingOccurrences(of: Constants.defaultSecondaryPromptInstructionPlaceholder, with: additional)
        
        correctedText = try await service.fetchCorrection(for: correctedText, prompt: extraInstructions ?? additionalInstructions)
    }
     
    //
    
}
