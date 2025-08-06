//
//  CorrectionEditorView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 17/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import SwiftData

struct CorrectionEditorView : View {
    @Bindable var viewModel: CorrectionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Original text")
            TextEditor(text: .constant(viewModel.textForCorrection))
            Text("Suggested correction")
            TextEditor(text: .constant(viewModel.correctedText))
            HStack {
                Spacer()
                Button(action: copyCorrectedText) {
                    Image(systemName: "doc.on.doc")
                }
                .disabled(viewModel.correctedText.isEmpty)
            }
            Text("Additional instructions")
            TextEditor(text: $viewModel.additionalInstructions)
        }
    }
    
    init(viewModel: CorrectionViewModel) {
        self.viewModel = viewModel
    }
    
    private func copyCorrectedText() {
        let pboard = NSPasteboard.general
        pboard.clearContents()
        pboard.setString(viewModel.correctedText, forType: .string)
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Prompt.self, configurations: config)
    let context = container.mainContext
    
    CorrectionEditorView(viewModel: CorrectionViewModel(apiKey: "foop", modelContext: context))
}
