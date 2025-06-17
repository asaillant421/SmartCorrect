//
//  CorrectionViewModel.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 13/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

@Observable
class CorrectionViewModel {
    var mainPrompt: String
    var secondaryPrompt: String
    var shouldSaveAdditionalInstructions = false
    private let apiKey: String
    
    var textForCorrection = ""
    var correctedText = ""
    var additionalInstructions = ""
    
    private let service: CorrectionService
    
    init(apiKey: String, text: String = "", mainPrompt: String = "", secondaryPrompt: String = "") {
        self.apiKey = apiKey
        self.textForCorrection = text
        self.mainPrompt = mainPrompt
        self.secondaryPrompt = mainPrompt
        service = CorrectionService(apiKey: apiKey)
    }
    
    func correctText() async throws {
        correctedText = try await service.fetchCorrection(for: textForCorrection, prompt: mainPrompt)
    }
    
    func improveCorrection() async throws {
        correctedText = try await service.fetchCorrection(for: correctedText, prompt: secondaryPrompt, additionalInstructions: additionalInstructions)
    }
}
