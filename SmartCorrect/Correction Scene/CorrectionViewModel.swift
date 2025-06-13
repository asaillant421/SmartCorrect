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
    var textForCorrection = ""
    var correctedText = ""
    var shouldSave: Bool = false
    var additionalInstructions = ""
    
    func correctText() async throws {
        let service = CorrectionService()
        correctedText = try await service.fetchCorrection(for: textForCorrection)
        
    }
}
