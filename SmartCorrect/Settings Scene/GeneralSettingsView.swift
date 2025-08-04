//
//  GeneralSettingsView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 11/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import ServiceManagement

struct GeneralSettingsView : View {
    @StateObject private var loginItemService = LoginItemService.shared
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @AppSecureStorage("apiKey") private var apiKey: String?
    @State private var startAtLogin = false
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $startAtLogin) {
                    Text("Start at Login")
                    Text("Start at Login: Automatically launch the app when you log in to your Mac.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .onChange(of: startAtLogin) { _, newValue in
                    do {
                        try loginItemService.setEnabled(newValue)
                    } catch {
                        // Revert the toggle if the operation failed
                        startAtLogin = loginItemService.isEnabled
                        print("Failed to update login item: \(error)")
                    }
                }
                Toggle(isOn: $showMenuBarExtra) {
                    Text("Show Icon on Menu Bar")
                    Text("Show Icon on Menu Bar: Display the app's icon in the menu bar for quick access.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("General")
            }
            
            Section {
                SecureField("OpenAI API Key", text: Binding(
                    get: { apiKey ?? "" },
                    set: { apiKey = $0.isEmpty ? nil : $0 }
                ), prompt: Text("sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"))
                .textFieldStyle(.roundedBorder)
            } header: {
                Text("API Configuration")
            } footer: {
                Text("Enter your OpenAI API key to enable text correction features. You can get one from openai.com.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            // Sync the toggle state with the actual login item status
            startAtLogin = loginItemService.isEnabled
        }
    }
}
