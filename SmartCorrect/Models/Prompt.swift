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

@Model
final class Prompt {
    var text: String
    var shortcut: String
    var name: String
    var shouldShowButton: Bool
    
    static let shouldShow: Predicate<Prompt> = #Predicate { prompt in
        prompt.shouldShowButton
    }
    
    init(text: String = "", shortcut: String = "", name: String = "", shouldShowButton: Bool = true) {
        self.text = text
        self.shortcut = shortcut
        self.name = name
        self.shouldShowButton = shouldShowButton
    }
}
