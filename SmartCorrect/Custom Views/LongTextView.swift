//
//  LongTextView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 16/07/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

struct LongTextView : View {
    @Binding var content: String
    
    init(content: Binding<String>) {
        self._content = content
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text(content)
                    .lineLimit(nil)
            }.frame(maxWidth: .infinity)
        }
    }
}
