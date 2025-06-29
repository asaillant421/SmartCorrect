//
//  CorrectionView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 12/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

struct CorrectionView : View {
    @Environment(\.openSettings) private var openSettings
    @Environment(CorrectionViewModel.self) var viewModel
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Improve Writing", systemImage: "sparkles")
            
            CorrectionEditorView(viewModel: viewModel)
            
            ExtraPromptButtonsView(viewModel: viewModel)
            
            CorrectionButtonFooterView(viewModel: viewModel)
        }
        .padding()
    }
    
    private func solicitAPIKey() {
        openSettings()
    }
}
