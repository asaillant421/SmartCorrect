//
//  SchemaVersions.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 08/08/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftData
import Foundation

// Schema Version 1 (Current - with source field)
enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [AILogEntryV1.self, PromptV1.self]
    }
    
    @Model
    final class AILogEntryV1 {
        var timestamp: Date
        var requestText: String
        var responseText: String
        var source: String
        
        init(timestamp: Date = Date(), requestText: String, responseText: String, source: String) {
            self.timestamp = timestamp
            self.requestText = requestText
            self.responseText = responseText
            self.source = source
        }
    }
    
    @Model
    final class PromptV1 {
        var text: String
        var shortcut: String
        var name: String
        var shouldShowButton: Bool
        var creationDate: Date
        
        init(text: String = "", shortcut: String = "", name: String = "", shouldShowButton: Bool = true, creationDate: Date = Date()) {
            self.text = text
            self.shortcut = shortcut
            self.name = name
            self.shouldShowButton = shouldShowButton
            self.creationDate = creationDate
        }
    }
}
