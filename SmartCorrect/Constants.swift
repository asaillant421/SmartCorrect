//
//  Constants.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 11/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation

enum WindowIdentifier : String, Codable, Identifiable {
    case smartCorrect = "smart-correct-window"
    case settingsWindow = "settings-window"
    
    var id: String { rawValue }
}

enum Constants {
    
    static let bundleIdentifier = "com.entopia.smartcorrect"
    static let defaultMainPrompt = "Improve and correct the following text. Focus on grammar, spelling, clarity, and style, while preserving the original tone and intent. Return only the corrected version."
    
    static let defaultSecondaryPromptPlaceholder = "[CORRECTED_TEXT]"
    static let defaultSecondaryPromptInstructionPlaceholder = "[USER_COMMANDS]"
    static let defaultSecondaryPrompt = """
    Below are additional instructions and a corrected version of a text. Preserve the text's structure and quality, but apply light edits based on the additional instructions to refine the text. Reply only with the refined text.
    
    Instructions:
    [USER_COMMANDS]
    
    Text:
    """
    
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    
    static let dateFormatter = DateFormatter()
}
