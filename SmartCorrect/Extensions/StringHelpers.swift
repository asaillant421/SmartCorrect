//
//  StringExtensions.swift
//
//  Created by Meir Radnovich on 17/01/2021.
//

import Foundation

fileprivate let numberyCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ",. "))

extension String {
    init<S: Sequence>(unicodeScalars ucs: S) where S.Iterator.Element == UnicodeScalar {
        var s: Self = ""
        s.unicodeScalars.append(contentsOf: ucs)
        self = s
    }
}

extension StringProtocol {
    
    public var d: Data {
        return data(using: .utf8) ?? Data()
    }
    
    public func partitioned(every stride: Int) -> [Self.SubSequence] {
        var result: [Self.SubSequence] = []
        let resultLength = (count / stride) + 1
        
        for i in 0...resultLength {
            guard let chunkStart = index(startIndex, offsetBy: i * stride, limitedBy: endIndex) else {
                break
            }
            
            let substr: Self.SubSequence
            
            if let chunkEnd = index(chunkStart, offsetBy: stride, limitedBy: endIndex) {
                substr = self[chunkStart..<chunkEnd]
            } else {
                substr = self[chunkStart...]
            }
            
            if substr.isEmpty {
                break
            }
            
            result.append(substr)
        }
        
        return result
    }
    
    func substring(with nsrange: NSRange) -> Self.SubSequence {
        return self[Range(nsrange, in: self)!]
    }
    
    var numeralsOnly: String {
        String(unicodeScalars: unicodeScalars.filter({ CharacterSet.decimalDigits.contains($0) }))
    }
    
    var numeric: String {
        String(unicodeScalars: unicodeScalars.filter({ numberyCharacters.contains($0) }))
    }
    
    var isNumeric: Bool {
        self == numeric
    }
    
    var doubleValue: Double? {
        Double(self)
    }
    
    var intValue: Int? {
        Int(self)
    }
    
    func percentEscaped() -> String? {
        var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
        allowedQueryParamAndKey.remove(charactersIn: ";/?:@&=+$, ")
        return addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)
    }
    
    func replacingCharacters(in nsrange: NSRange, with replacement: Self) -> String {
        guard let swiftRange = Range(nsrange, in: self) else {
            return String(self)
        }
        
        return replacingCharacters(in: swiftRange, with: replacement)
    }
}
