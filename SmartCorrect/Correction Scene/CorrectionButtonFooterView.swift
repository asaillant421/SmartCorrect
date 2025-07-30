//
//  CorrectionButtonFooterView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 17/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import SwiftData

struct CorrectionButtonFooterView : View {
    @Bindable var viewModel: CorrectionViewModel
    
    var body: some View {
        HStack {
            Toggle(isOn: $viewModel.shouldSaveAdditionalInstructions) {
                Text("Store this update and use it to improve future suggestions based on your preferences.")
            }
            Spacer()
            
            Button("Paste Correction") {
                Task.detached {
                    await viewModel.pasteCorrection()
                }
            }
            .disabled(viewModel.correctedText.isEmpty)
            
            Button("Ask ChatGPT") {
                Task {
                    try await viewModel.correctText()
                }
            }
            .disabled(viewModel.textForCorrection.isEmpty)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Prompt.self, configurations: config)
    let context = container.mainContext
    
    CorrectionButtonFooterView(viewModel: CorrectionViewModel(apiKey: "foop", modelContext: context))
}
