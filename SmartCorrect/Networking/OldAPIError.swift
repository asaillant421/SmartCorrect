//
//  APIError.swift
//
//  Created by Meir Radnovich on 27 Tammuz 5782.
//

import Foundation

enum OldAPIError : Error, LocalizedError {
    case notLoggedIn
    case decodingError(String)
    case decodingKeyNotFound(String)
    case decodingValueNotFound(Any.Type, String)
    case encodingError(Encodable)
    case badURL(String)
    case badArgument(String)
//    case serverError(ServerError)
    case missingUsername
    case unknownError(Error)
    case xpc
    
    init(error: Error) {
        switch error {
        case let api as OldAPIError:
            self = api
//        case let svr as ServerError:
//            self = .serverError(svr)
        default:
            self = .unknownError(error)
        }
    }
    
    var errorDescription: String? {
        switch self {
        case let .encodingError(encodable):
            return "Unable to encode \(encodable)"
        case let .unknownError(err):
            return err.localizedDescription
//        case let .serverError(svr):
//            return svr.localizedDescription
        case .notLoggedIn:
            return "Not Logged In"
        case let .badArgument(errorMessage):
            return errorMessage
        case let .badURL(url):
            return "Couldn't get the components from \(url)"
        case let .decodingError(errorMessage):
            return "Decoding error: \(errorMessage)"
        case let .decodingKeyNotFound(missingKey):
            return "Key not found: \(missingKey)"
        case let .decodingValueNotFound(type, context):
            return "Missing \(type) value in context \(context)"
        case .missingUsername:
            return "Couldn't extract username from AuthPlugin.Context"
        case .xpc:
            return "Unable to reach XPC Service"
        }
    }
}
