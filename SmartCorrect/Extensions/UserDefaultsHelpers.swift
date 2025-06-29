//
//  UserDefaultsHelpers.swift
//
//  Created by מאיר רדנוביץ׳ on 27 Tamuz 5782.
//

import Foundation
import os.log

enum UserDefaultsKey : String, CaseIterable {
    case host = "com.entopia.host"
    case token = "com.entopia.authToken"
    case emailPassword = "com.entopia.emailPassword"
    
    var shouldDeleteOnHostChange: Bool {
        switch self {
        case .token:
            return true
        case .host:
            return false
        case .emailPassword:
            return true
        }
    }
}

extension UserDefaults {
    func clearHostBased() {
        let keysToWipe = UserDefaultsKey.allCases.filter({ $0.shouldDeleteOnHostChange })
        
        for key in keysToWipe {
             removeValue(for: key)
        }
    }
    
    func set<T>(value: T?, for key: UserDefaultsKey) where T: Encodable {
        guard let val = value else {
            set(nil, forKey: key.rawValue)
            return
        }
        
        switch val {
//        NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary.
        case let d as Data:
            set(d, forKey: key.rawValue)
        case let str as String:
            set(str, forKey: key.rawValue)
        case let date as Date:
            set(date, forKey: key.rawValue)
        case let ary as [Any]: // FIXME: Arrays of non-plist items will fail
            set(ary, forKey: key.rawValue)
        case let dict as [String:Any]:
            set(dict, forKey: key.rawValue)
        case let i as Int:
            set(i, forKey: key.rawValue)
        case let d as Double:
            set(d, forKey: key.rawValue)
        case let f as Float:
            set(f, forKey: key.rawValue)
        case let url as URL:
            set(url.absoluteString, forKey: key.rawValue)
        case let guid as UUID:
            set(guid.uuidString, forKey: key.rawValue)
        default:
            do {
                let enc = JSONEncoder()
                let d = try enc.encode(val)
                set(d, forKey: key.rawValue)
            } catch {
                set(val, forKey: key.rawValue)
            }
        }
    }

    func value<T>(for key: UserDefaultsKey) -> T? where T: Decodable {
        let type = T.self
//          let res: T
        switch type {
        case is UUID.Type:
            if let s = string(forKey: key.rawValue),
               let uuid = UUID(uuidString: s) {
                return uuid as? T
            } else {
                return nil
            }
        case is String.Type:
            return string(forKey: key.rawValue) as? T
        case is Int.Type:
            return integer(forKey: key.rawValue) as? T
        case is [String].Type:
            return stringArray(forKey: key.rawValue) as? T
        case is [Any].Type:
            return array(forKey: key.rawValue) as? T
        case is [String:Any].Type:
            return dictionary(forKey: key.rawValue) as? T
        case is Data.Type:
            return data(forKey: key.rawValue) as? T
        case is Float.Type:
            return float(forKey: key.rawValue) as? T
        case is Double.Type:
            return double(forKey: key.rawValue) as? T
        case is Bool.Type:
            return bool(forKey: key.rawValue) as? T
        case is URL.Type:
            return url(forKey: key.rawValue) as? T
        default:
            if let d = data(forKey: key.rawValue) {
                let decoder = JSONDecoder()
                
                do {
                    return try decoder.decode(T.self, from: d)
                } catch {
                    os_log(.error, "error decoding %{public}@: %{public}@", "\(T.self)", error.localizedDescription)
                    return nil
                }
            } else {
                return object(forKey: key.rawValue) as? T
            }
        }
    }
    
    func removeValue(for key: UserDefaultsKey) {
        removeObject(forKey: key.rawValue)
    }
}
