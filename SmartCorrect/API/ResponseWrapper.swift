//
//  ResponseWrapper.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 26/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation

enum ResponseWrapper<C: Decodable> : Decodable {
    case success(C)
    case failure(APIError)
    
    init(from decoder: Decoder) throws {
        do {
            let c = try C(from: decoder)
            self = .success(c)
        } catch let dec as DecodingError {
            let apiError: APIError
            switch dec {
            case .keyNotFound(_, _):
                let errorContainer = try decoder.container(keyedBy: CodingKeys.self)
                apiError = try errorContainer.decode(APIError.self, forKey: .error)
            case let .dataCorrupted(context):
                apiError = APIError(message: context.debugDescription, type: "corrupt_json", param: nil, code: nil)
            case let .typeMismatch(type, _):
                apiError = APIError(message: "JSON type mismatch: \(type)", type: "json_type_mismatch", param: nil, code: "json_type_mismatch")
            case let .valueNotFound(type, _):
                apiError = APIError(message: "JSON expected value missing for \(type)", type: "json_value_missing", param: nil, code: "json_value_missing")
            @unknown default:
                apiError = APIError(message: "Unknown and unexpected DecodingError", type: "unknown_decoding_error", param: "\(dec)", code: "unknown_decoding_error")
            }
            self = .failure(apiError)
        } catch {
            let errorContainer = try decoder.container(keyedBy: CodingKeys.self)
            let e = try errorContainer.decode(APIError.self, forKey: .error)
            self = .failure(e)
        }
    }
    
    enum CodingKeys: CodingKey {
        case error
    }
}


extension ResponseWrapper : Encodable where C : Encodable {
    func encode(to encoder: Encoder) throws {
        switch self {
        case let .success(c):
            try c.encode(to: encoder)
        case let .failure(e):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(e, forKey: .error)
        }
    }
}
