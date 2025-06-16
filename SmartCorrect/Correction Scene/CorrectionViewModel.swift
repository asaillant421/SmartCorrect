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
    @AppStorage("mainPrompt") private var mainPrompt: String?
    @AppSecureStorage("apiKey") private var apiKey: String? {
        didSet {
            guard let apiKey, !apiKey.isEmpty else {
                service = nil
                return
            }
            
            service = CorrectionService(apiKey: apiKey)
        }
    }
    
    var textForCorrection = ""
    var correctedText = ""
    @AppStorage("shouldSaveAdditionalInstructions") var shouldSaveAdditionalInstructions: Bool = false
    var additionalInstructions = ""
    
    private var service: CorrectionService?
    
    init() {
        
    }
    
    func correctText() async throws {
        correctedText = try await service.fetchCorrection(for: textForCorrection, usingPrompt: mainPrompt ?? Constants.defaultMainPrompt)
    }
}
