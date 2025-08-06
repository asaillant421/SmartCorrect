//
//  SmartCorrectNotifications.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 12/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import Foundation

extension Notification {
    static let selectedTextKey = "selectedTextKey"
}

extension Notification.Name {
    static let serviceActivated = Self("SmartCorrectServiceActivatedNotification")
    static let orderedFront = Self("SmartCorrectOrderedFrontNotification")
    static let menuBarExtraToggled = Self("menuBarExtraToggled")
}
