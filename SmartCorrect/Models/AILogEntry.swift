//
//  AILogEntry.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 07/08/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class AILogEntry {
    var timestamp: Date
    var requestText: String
    var responseText: String
    
    init(timestamp: Date = Date(), requestText: String, responseText: String) {
        self.timestamp = timestamp
        self.requestText = requestText
        self.responseText = responseText
    }
}