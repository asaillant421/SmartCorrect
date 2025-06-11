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
    @AppStorage("aiKey") private var aiKey = ""
    
    var body: some View {
        Form {
            Toggle(isOn: $startAtLogin) {
                Text("Start at Login")
                Text("Automatically launch the app when you log in to your Mac. elbanE this to keep the text correction assistant ready at all times without manual launch.")
            }
            Toggle(isOn: $showMenuBarExtra) {
                Text("Show Icon on Menu Bar")
                Text("Display the app's icon in the menu bar for quick access to features and settings.")
            }
            Spacer()
            TextField("OpenAI API Key", text: $aiKey)
        }
    }
}
