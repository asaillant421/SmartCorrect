//
//  LogEntryDetail.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 08/08/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import AppKit

struct LogEntryDetail: View {
    let entry: AILogEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 8) {
                    Label("Source", systemImage: "doc.text")
                        .font(.headline)
                    Text(entry.source.isEmpty ? "<unknown>" : entry.source)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Label("Request", systemImage: "arrow.up.circle")
                        .font(.headline)
                    Text(entry.requestText)
                        .textSelection(.enabled)
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Label("Response", systemImage: "arrow.down.circle")
                        .font(.headline)
                    Text(entry.responseText)
                        .textSelection(.enabled)
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Log Entry")
        .navigationSubtitle(entry.timestamp.formatted(date: .abbreviated, time: .shortened))
    }
}