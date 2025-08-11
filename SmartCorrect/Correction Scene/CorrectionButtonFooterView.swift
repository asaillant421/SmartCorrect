//
//  CorrectionButtonFooterView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 17/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import SwiftData
import AppKit

struct CorrectionButtonFooterView : View {
    @Bindable var viewModel: CorrectionViewModel
    
    var body: some View {
        HStack {
            Toggle(isOn: $viewModel.shouldSaveAdditionalInstructions) {
                Text("Store this update and use it to improve future suggestions based on your preferences.")
            }
            Spacer()
            
            Button(action: pasteCorrection) {
                HStack(spacing: 4) {
                    if let icon = viewModel.sourceAppIcon {
                        Image(nsImage: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    }
                    
                    if viewModel.sourceAppName.isEmpty {
                        Text("Paste Correction")
                    } else {
                        Text("Paste to \(viewModel.sourceAppName)")
                    }
                }
            }
            .disabled(viewModel.correctedText.isEmpty)
            
            Button(action: askChatGPT) {
                Text("Ask ChatGPT")
            }
            .disabled(viewModel.textForCorrection.isEmpty)
        }
    }
    
    private func pasteCorrection() {
        Task.detached {
            await viewModel.pasteCorrection()
        }
    }
    
    private func askChatGPT() {
        Task.detached {
            try! await viewModel.correctText()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Prompt.self, configurations: config)
    let context = container.mainContext
    
    CorrectionButtonFooterView(viewModel: CorrectionViewModel(apiKey: "foop", modelContext: context))
}
