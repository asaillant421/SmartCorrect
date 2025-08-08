//
//  CorrectionService.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 09/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import SwiftData
import Foundation

actor CorrectionService {
    private let apiKey: String
    private let model: GPTModel
    private let modelContext: ModelContext
    
    init(apiKey: String, modelContext: ModelContext, model: GPTModel = .gpt35turbo) {
        self.apiKey = apiKey
        self.modelContext = modelContext
        self.model = model
    }
    
    func fetchCorrection(for text: String, in origin: String, prompt: String = Constants.defaultMainPrompt) async throws -> String {
        guard !origin.isEmpty else { return text }
        
        let paramsForChatGPT = [prompt, text].joined(separator: "\n\n")
        
        let request = ResponsesAPIRequest(model: model, input: paramsForChatGPT)
        
        // Encode request to JSON for logging
        let requestData = try JSONEncoder().encode(request)
        let requestJSON = String(data: requestData, encoding: .utf8) ?? ""
        
        let response: ResponsesAPIResponse = try await APIManager.shared.sendRequest(endpoint: .responses, params: request, authToken: "Bearer \(apiKey)")
        
        // Encode response to JSON for logging
        let responseData = try JSONEncoder().encode(response)
        let responseJSON = String(data: responseData, encoding: .utf8) ?? ""
        
        // Create AILogEntry
        let logEntry = AILogEntry(
            requestText: requestJSON,
            responseText: responseJSON,
            source: origin
        )
        
        await MainActor.run {
            modelContext.insert(logEntry)
            try? modelContext.save()
        }
        
        guard let output = response.output.first,
              let content = output.content.first,
              let outputText = content.text else {
            throw APIError(message: "Response had no valid text content", type: "invalid_response", param: response.id, code: "invalid_response")
        }
        
        return outputText
    }
    
    
}
