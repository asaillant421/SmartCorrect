//
//  NetworkingConstants.swift
//
//  Created by Meir Radnovich on 27 Tammuz 5782.
//

import Foundation

extension TimeZone {
    static let UTC = TimeZone(identifier: "UTC")!
}

enum NetworkingConstants
{
    
    enum MimeType : String, CustomStringConvertible {
        case JSON = "application/json"
        case FormData = "multipart/form-data"
        case PNG = "image/png"
        case JPEG = "image/jpeg"
        
        var description: String {
            rawValue
        }
    }
    
    // HTTP Headers
    
    static let ContentType = "Content-Type"
    static let Authorisation = "Authorization"
    static let Accept = "Accept"
    static let UserID = "User-Identifier"
    static let PaymentIntent = "Client-Secret"
    
    static let upsReferenceDate: Date = {
        let components = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: .UTC, era: nil, year: 2000, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)
        
        return components.date!
    }()
    
    static let dateOnlyFormatter: DateFormatter = {
        let dof = DateFormatter()
        
        dof.dateFormat = "yyyy-MM-dd"
        dof.timeZone = .autoupdatingCurrent // Change this depending on the user's timezone
        
        return dof
    }()
    
    static let timeOnlyFormatter: DateFormatter = {
        let dof = DateFormatter()
        
        dof.dateFormat = "HH:mm:ss"
        dof.timeZone = .UTC // Confirm...
        
        return dof
    }()

    static let queue = DispatchQueue(label: "com.entopia.queue.api", qos: .userInitiated, attributes: [.concurrent], autoreleaseFrequency: .workItem, target: nil)
}

enum APIHost: Int
{
    case development = 1
    case staging = 2
    case production = 3
    case testing = 4
    
    var name: String {
        switch self {
        case .development:
            return "Development"
        case .staging:
            return "Staging"
        case .production:
            return "Production"
        case .testing:
            return NSLocalizedString("User Testing", comment: "")
        }
    }

    // TODO: Switch if there are any additional options
    var server: String { "api.openai.com" }
    var version: String { "v1" }
    
    var url: String {
        return "https://\(server)/\(version)"
    }
}

enum HTTPMethod: String
{
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    
    var acceptsBody: Bool {
        switch self {
        case .post, .patch, .put:
            return true
        case .get, .delete:
            return false
        }
    }
}
