//
//  CorrectionView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 12/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import Combine

struct CorrectionView : View {
    @Environment(\.openSettings) private var openSettings
    @Environment(CorrectionViewModel.self) var viewModel
    @Environment(\.modelContext) var modelContext
    private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Improve Writing", systemImage: "sparkles")
            
            CorrectionEditorView(viewModel: viewModel)
            
            ExtraPromptButtonsView(viewModel: viewModel)
            
            CorrectionButtonFooterView(viewModel: viewModel)
        }
        .padding()
        .frame(width: 800, height: 600)
        .onAppear {
            CorrectionView.updateAndCorrect(vm: viewModel)
        }
    }
    
    init() {
    }
    
    private static func updateAndCorrect(vm: CorrectionViewModel) {
        
        Task.detached(priority: .background) {
            await vm.findSelectedText()
            
            if vm.correctedText.isEmpty {
                try await vm.correctText()
            }
        }
    }
    
    private func solicitAPIKey() {
        openSettings()
    }
}
