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
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchCorrection(for text: String, prompt: String = Constants.defaultMainPrompt, additionalInstructions: String? = nil) async throws -> String {
        return await Task {
            return String(text.reversed())
        }.value
    }
    

}
