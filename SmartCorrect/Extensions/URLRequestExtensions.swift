//
//  URLRequestExtensions.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 26/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation

extension URLRequest {
    var betterDescription: String {
        "\(String(describing: httpMethod)) \(String(describing: url)), Headers:\t\(String(describing: allHTTPHeaderFields)), Body:\t\(httpBody?.s ?? "<none>")"
    }
}
