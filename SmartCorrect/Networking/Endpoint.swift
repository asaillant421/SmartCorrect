//
//  Endpoint.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 28 Tamuz 5782.
//

import Foundation

enum Endpoint {
    case responses
    case chatCompletion
    
    var path: String {
        switch self {
        case .responses:
            return "responses"
        case .chatCompletion:
            return "chat/completion"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .responses, .chatCompletion:
            return .post
        }
    }
    
    private var host: APIHost {
        HostManager.shared.selectedHost
    }
    
    var url: URL? {
        URL(string: host.url)?.appendingPathComponent(path)
    }
}
