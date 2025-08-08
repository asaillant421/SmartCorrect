//
//  CorrectionLogsView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 11/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import SwiftData

struct CorrectionLogsView : View {
    @Query(sort: \AILogEntry.timestamp, order: .reverse) var logEntries: [AILogEntry]
    @State private var selectedEntry: AILogEntry?
    
    var body: some View {
        NavigationSplitView {
            List(logEntries, id: \.timestamp, selection: $selectedEntry) { entry in
                LogEntryRow(entry: entry)
                    .tag(entry)
            }
            .navigationTitle("Correction Logs")
        } detail: {
            if let selectedEntry = selectedEntry {
                LogEntryDetail(entry: selectedEntry)
            } else {
                ContentUnavailableView(
                    "No Selection",
                    systemImage: "clock.arrow.circlepath",
                    description: Text("Select a log entry to view details")
                )
            }
        }
    }
}

struct LogEntryRow: View {
    let entry: AILogEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.timestamp, style: .offset)
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

struct LogEntryDetail: View {
    let entry: AILogEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
