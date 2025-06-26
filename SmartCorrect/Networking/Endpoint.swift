//
//  Endpoint.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 28 Tamuz 5782.
//

import Foundation

enum Endpoint {
    case createSession
    case refreshToken
    case createAccount
    case fetchAccountDetails
    case fetchLatestVersion
    case download(URL)
    
    var path: String {
        switch self {
        case .createSession, .refreshToken:
            return "session"
        case .createAccount, .fetchAccountDetails:
            return "account"
        case .fetchLatestVersion:
            return "version.json"
        case let .download(custom):
            return custom.path
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createAccount, .createSession:
            return .post
        case .fetchAccountDetails, .fetchLatestVersion, .download:
            return .get
        case .refreshToken:
            return .put
        }
    }
    
    private var host: APIHost {
        HostManager.shared.selectedHost
    }
    
    var url: URL? {
        switch self {
        case let .download(custom):
            return custom
        default:
            return URL(string: host.url)?.appendingPathComponent(path)
        }
    }
}
