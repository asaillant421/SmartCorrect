//
//  SettingsView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 11/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

struct SettingsView : View {
    var body: some View {
            TabView {
                Tab("General", systemImage: "gearshape") {
                    GeneralSettingsView()
                }
                Tab("Shortcuts & Prompts", systemImage: "command") {
                    ShortcutsAndPromptsSettingsView()
                }
                Tab("Correction Logs", systemImage: "clock.arrow.circlepath") {
                    CorrectionLogsView()
                }
                Tab("GPT Training", systemImage: "sparkles") {
                    TrainingView()
                }
            }
            .scenePadding()
        }
}
