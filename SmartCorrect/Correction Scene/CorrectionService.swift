//
//  CorrectionService.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 09/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

actor CorrectionService {
    @AppSecureStorage("apiKey") private var apiKey: String?
    @AppStorage("prompt") private var prompt = ""
    
    func fetchCorrection(for text: String) async throws -> String {
        return text
    }
}
