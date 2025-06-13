//
//  AppSecureStorage.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 11/06/2025.
//  Based on https://dev.to/bsorrentino/swiftui-a-property-wrapper-to-secure-settings-19p6
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import KeychainAccess

@propertyWrapper
public struct AppSecureStorage : DynamicProperty {
    private let key: String
    private let accessibility: Accessibility
    private let keychain = Keychain(service: "com.entopia.smartcorrect")
    
    public var wrappedValue: String? {
        get {
            try? keychain.getString(key)
        }
        nonmutating set {
            if let newValue, !newValue.isEmpty {
                try? keychain.set(newValue, key: key)
            }
        }
    }
    
    public init(
        _ key: String,
        accessibility: Accessibility = .whenUnlocked
    ) {
        self.key = key
        self.accessibility = accessibility
    }
}
