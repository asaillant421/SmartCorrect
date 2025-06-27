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
        
        let paramsForChatGPT: String
        
        if let additionalInstructions {
            paramsForChatGPT = [prompt, text, additionalInstructions].joined(separator: "\n\n")
        } else {
            paramsForChatGPT = [prompt, text].joined(separator: "\n\n")
        }
        
        let request = ResponsesAPIRequest(model: model, input: paramsForChatGPT)
        
        let response: ResponsesAPIResponse = try await APIManager.shared.sendRequest(endpoint: .responses, params: request, authToken: "Bearer \(apiKey)")
        
        return response.outputText ?? text
    }
    

}
