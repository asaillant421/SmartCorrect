//
//  GeneralSettingsView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 11/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

struct GeneralSettingsView : View {
    @AppStorage("startAtLogin") private var startAtLogin = false
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @AppSecureStorage("apiKey") private var apiKey: String?
    
    var body: some View {
        Form {
            Section {
                Toggle("Start at Login", isOn: $startAtLogin)
                Toggle("Show Icon on Menu Bar", isOn: $showMenuBarExtra)
            } header: {
                Text("General")
            } footer: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Start at Login: Automatically launch the app when you log in to your Mac.")
                    Text("Show Icon on Menu Bar: Display the app's icon in the menu bar for quick access.")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
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
    }
}
