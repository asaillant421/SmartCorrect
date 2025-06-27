//
//  URLResponseExtensions.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 26/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation

extension URLResponse {
    @objc var betterDescription: String {
        "\(String(describing: url)), Mime: \(String(describing: mimeType))"
    }
}

extension HTTPURLResponse {
    @objc override var betterDescription: String {
        "\(statusCode) \(String(describing: url)), Headers:\(String(describing: allHeaderFields))"
    }
}
