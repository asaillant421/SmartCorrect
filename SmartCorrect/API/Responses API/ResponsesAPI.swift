//
//  ResponsesAPI.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 25/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation

actor ResponsesAPI {
    private static let baseURL = URL(string: "https://api.openai.com/v1")!.appendingPathComponent("responses")
    
    func post(request: ResponsesAPIRequest) async throws -> ResponsesAPIResponse {
        
    }
}
