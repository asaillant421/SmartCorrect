//
//  LoginItemService.swift
//  SmartCorrect
//
//  Created by Claude on 01/08/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation
import ServiceManagement

@MainActor
class LoginItemService: ObservableObject {
    static let shared = LoginItemService()
    
    private init() {}
    
    var isEnabled: Bool {
        get {
            SMAppService.mainApp.status == .enabled
        }
    }
    
    func setEnabled(_ enabled: Bool) throws {
        if enabled {
            if SMAppService.mainApp.status == .enabled {
                return // Already enabled
            }
            try SMAppService.mainApp.register()
        } else {
            if SMAppService.mainApp.status != .enabled {
                return // Already disabled
            }
            try SMAppService.mainApp.unregister()
        }
    }
    
    func updateStatus() {
        objectWillChange.send()
    }
}