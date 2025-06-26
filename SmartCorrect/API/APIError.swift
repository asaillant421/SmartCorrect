//
//  APIError.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 25/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//


struct APIError: Codable, Error {
    let message: String
    let type: String?
    let param: String?
    let code: String?
}
