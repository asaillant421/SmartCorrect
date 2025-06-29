//
//  CorrectionEditorView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 17/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

struct CorrectionEditorView : View {
    @Bindable var viewModel: CorrectionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Original text")
            TextEditor(text: $viewModel.textForCorrection)
            Text("Suggested correction")
            TextEditor(text: $viewModel.correctedText)
            Text("Additional instructions")
            TextEditor(text: $viewModel.additionalInstructions)
        }
    }
    
    init(viewModel: CorrectionViewModel) {
        self.viewModel = viewModel
    }
}

#Preview {
    CorrectionEditorView(viewModel: CorrectionViewModel(apiKey: "foop"))
}
