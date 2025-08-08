//
//  CorrectionLogsView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 11/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import SwiftData
import AppKit

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
                
                Button {
                    exportLogEntries()
                } label: {
                    Text("Export")
                }
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
    
    
    private func exportLogEntries() {
        let logContent = createLogFileContent()
        showSavePanel(content: logContent)
    }
    
    private func createLogFileContent() -> String {
        var content = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        
        for (index, entry) in filteredLogEntries.enumerated() {
            if index > 0 {
                content += "\n" + String(repeating: "=", count: 80) + "\n\n"
            }
            
            // Header with source and timestamp
            let source = entry.source.isEmpty ? "<unknown>" : entry.source
            content += "Source: \(source)\n"
            content += "Timestamp: \(dateFormatter.string(from: entry.timestamp))\n\n"
            
            // Request JSON (pretty-printed)
            content += "REQUEST:\n"
            content += prettyPrintJSON(entry.requestText)
            content += "\n\n"
            
            // Response JSON (pretty-printed)
            content += "RESPONSE:\n"
            content += prettyPrintJSON(entry.responseText)
            content += "\n"
        }
        
        return content
    }
    
    private func prettyPrintJSON(_ jsonString: String) -> String {
        guard let jsonData = jsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            // If JSON parsing fails, return the original string
            return jsonString
        }
        return prettyString
    }
    
    private func showSavePanel(content: String) {
        let savePanel = NSSavePanel()
        savePanel.title = "Export Correction Logs"
        savePanel.message = "Choose where to save the log file"
        savePanel.nameFieldStringValue = "correction_logs_\(Date().formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).txt"
        savePanel.allowedContentTypes = [.plainText]
        savePanel.canCreateDirectories = true
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                do {
                    try content.write(to: url, atomically: true, encoding: .utf8)
                } catch {
                    // Handle error - could show an alert here
                    print("Failed to save log file: \(error.localizedDescription)")
                }
            }
        }
    }
}