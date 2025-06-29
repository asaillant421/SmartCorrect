//
//  DataExtensions.swift
//
//  Created by Meir Radnovich on 17/01/2021.
//

import Foundation

extension Data {
    public var debugDescription: String {
        s
    }
    
    public var s: String {
        String(data: self, encoding: .utf8) ?? byteDescription
    }
    
    public var byteDescription: String {
        let bytes = map { String.localizedStringWithFormat("%02X", $0) }.joined()
        
        return bytes.partitioned(every: 8).joined(separator: " ")
    }
}
