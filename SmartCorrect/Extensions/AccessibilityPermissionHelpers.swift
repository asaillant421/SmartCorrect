//
//  AccessibilityPermissionHelpers.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 13/07/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//  Based on https://stackoverflow.com/a/74912493

import SwiftUI
import Combine

@available(macOS 15.0, *)
public extension View {
    func checkAccessibility(interval: TimeInterval, access: Binding<Bool>) -> some View {
        modifier( AccessibilityCheckModifier(interval: interval, access: access) )
    }
    
    func checkAccessibilityOnAppear(access: Binding<Bool>) -> some View {
        onAppear {
            let checkOptionPrompt = kAXTrustedCheckOptionPrompt.takeRetainedValue() as String
            let options = [checkOptionPrompt : true] as CFDictionary
            access.wrappedValue = AXIsProcessTrustedWithOptions(options)
        }
    }
}

@available(macOS 15.0, *)
public struct AccessibilityCheckModifier: ViewModifier {
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var access: Bool
    
    init(interval: TimeInterval, access: Binding<Bool>) {
        timer = Timer.publish(every: interval, on: .current, in: .common).autoconnect()
        _access = access
    }
    
    public func body(content: Content) -> some View {
        content
            .onReceive(timer) { _ in
                let privAccess = AXIsProcessTrusted()
                
                if self.access != privAccess {
                    self.access = privAccess
                }
            }
    }
}
