//
//  GPTModel.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 25/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

enum GPTModel : String, Codable {
    case gpt35turbo = "gpt-3.5-turbo"
//    case gpt4o
    case o4mini = "o4-mini"
    case gpt41mini = "gpt-4.1-mini" // Free tier: 3/minute, 200/day, 40000 tokens/month
    // TODO: Add more models
    
}
