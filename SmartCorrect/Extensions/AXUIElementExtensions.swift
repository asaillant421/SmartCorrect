//
//  AXUIElementExtensions.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 07/07/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import ApplicationServices

extension AXUIElement {
    func findPid() -> pid_t? {
        var pid: pid_t = 0
        let result = AXUIElementGetPid(self, &pid)
        
        guard result == .success else {
            print("The pid was not found: \(result)")
            return nil
        }
        
        print("The pid was found: \(pid)")
        
        return pid
    }
}
