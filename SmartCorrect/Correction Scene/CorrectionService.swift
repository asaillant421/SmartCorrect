//
//  CorrectionService.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 09/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

actor CorrectionService {
    private let apiKey: String
    private let model: GPTModel
    
    init(apiKey: String, model: GPTModel = .gpt35turbo) {
        self.apiKey = apiKey
        self.model = model
    }
    
    func fetchCorrection(for text: String, prompt: String = Constants.defaultMainPrompt, additionalInstructions: String? = nil) async throws -> String {
        return await Task {
            return String(text.reversed())
        }.value
    }
    

}
