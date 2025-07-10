//
//  CorrectionButtonFooterView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 17/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

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
    CorrectionButtonFooterView(viewModel: CorrectionViewModel(apiKey: "foop"))
}
