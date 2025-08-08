//
//  LogFiltersView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 08/08/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import AppKit

struct LogFiltersView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var originatingApp: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading) {
                Text("Start Date")
                    .font(.caption)
                    .foregroundColor(.secondary)
                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
            
            VStack(alignment: .leading) {
                Text("End Date")
                    .font(.caption)
                    .foregroundColor(.secondary)
                DatePicker("", selection: $endDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
            
            VStack(alignment: .leading) {
                Text("Source")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Source", text: $originatingApp)
            }
        }
        .padding()
    }
}
