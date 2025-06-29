//
//  ResponsesAPIRequest.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 25/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation

struct ResponsesAPIRequest : Codable {
    let model: GPTModel
    let input: String
}
