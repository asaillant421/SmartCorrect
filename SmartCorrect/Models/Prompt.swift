//
//  Prompt.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 22/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation
import SwiftData
import KeyboardShortcuts

// Type alias to maintain compatibility with existing code
typealias Prompt = SchemaV1.PromptV1

extension SchemaV1.PromptV1 {
    static let shouldShow: Predicate<SchemaV1.PromptV1> = #Predicate { prompt in
        prompt.shouldShowButton
    }
}
