//
//  LogEntryRow.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 08/08/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

struct LogEntryRow: View {
    let entry: AILogEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.source.isEmpty ? "<unknown>" : entry.source)
                .font(.headline)
                .foregroundColor(.primary)
            HStack(alignment: .center, spacing: 2) {
                Text(entry.timestamp, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(entry.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}