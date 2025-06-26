//
//  CodableExtensions.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 25/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation


extension Encodable {
    func encodeJSON() throws -> Data {
        try Constants.encoder.encode(self)
    }
}

extension Data {
    func decodeJSON<D: Decodable>() throws -> D {
        try Constants.decoder.decode(D.self, from: self)
    }
}
