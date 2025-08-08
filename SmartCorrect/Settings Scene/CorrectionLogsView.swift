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
    @Query(sort: \AILogEntry.timestamp, order: .reverse) var allLogEntries: [AILogEntry]
    @State private var selectedEntry: AILogEntry?
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Date()
    @State private var originatingApp: String = ""
    
    private var filteredLogEntries: [AILogEntry] {
        let calendar = Calendar.current
        let startOfStartDate = calendar.startOfDay(for: startDate)
        let endOfEndDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate)) ?? endDate
        
        if originatingApp.isEmpty {
            return allLogEntries.filter { entry in
                entry.timestamp >= startOfStartDate && entry.timestamp < endOfEndDate
            }
        } else {
            return allLogEntries.filter { entry in
                entry.source.contains(originatingApp) && entry.timestamp >= startOfStartDate && entry.timestamp < endOfEndDate
            }
        }
            
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
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

                Spacer()
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            NavigationSplitView {
                List(filteredLogEntries, id: \.timestamp, selection: $selectedEntry) { entry in
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
        .onChange(of: startDate) { _, _ in
            selectedEntry = nil
        }
        .onChange(of: endDate) { _, _ in
            selectedEntry = nil
        }
        .onChange(of: originatingApp) { _, _ in
            selectedEntry = nil
        }
    }
}

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
