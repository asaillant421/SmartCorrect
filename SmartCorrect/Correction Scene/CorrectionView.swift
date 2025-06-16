//
//  CorrectionView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 12/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

struct CorrectionView : View {
    @State private var viewModel = CorrectionViewModel()
    @AppStorage("textForCorrection") var textForCorrection: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Improve Writing", systemImage: "sparkles")
            
            TextEditor(text: $textForCorrection)
            
            TextEditor(text: $viewModel.correctedText)
            
            TextEditor(text: $viewModel.additionalInstructions)
            
            HStack {
                Button("Make more formal") {
                    // TODO
                }
                
                Button("Use more humor") {
                    // TODO
                }
            }
            
            HStack {
                Toggle(isOn: $viewModel.shouldSave) {
                    Text("Store this update and use it to improve future suggestions based on your preferences.")
                }
                Spacer()
                
                Button("Paste Correction") {
                    // TODO
                }
                .disabled(viewModel.correctedText.isEmpty)
                
                Button("Ask ChatGPT") {
                    // TODO
                }
                .disabled(textForCorrection.isEmpty)
            }
        }
        .padding()
    }
}
