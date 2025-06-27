//
//  Constants.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 11/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation

enum WindowIdentifier : String {
    case smartCorrect = "smart-correct-window"
    case settingsWindow = "settings-window"
}

enum Constants {
    
    static let bundleIdentifier = "com.entopia.smartcorrect"
    static let defaultMainPrompt = "Improve and correct the following text in its original language. Focus on grammar, spelling, clarity, and style, while preserving the original tone and intent. Return only the corrected version."
    
    static let defaultSecondaryPrompt = """
    You are given a corrected version of a text. Preserve its structure and quality, but apply light edits based on the following instructions.
    
    Text:
    [CORRECTED_TEXT]
    
    Instructions:
    [USER_COMMANDS]
    
    Only return the revised text with the changes applied.
    """
    
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    
    static let dateFormatter = DateFormatter()
}
