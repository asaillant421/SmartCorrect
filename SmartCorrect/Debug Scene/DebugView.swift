//
//  DebugView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 16/07/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

struct DebugView: View {
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        Button("Debug") {
            openWindow(id: WindowIdentifier.smartCorrect.id)
        }
    }
}
