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
    @State private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(viewModel.currentPromptName, systemImage: "sparkles")
            
            CorrectionEditorView(viewModel: viewModel)
            
            ExtraPromptButtonsView(viewModel: viewModel)
            
            CorrectionButtonFooterView(viewModel: viewModel)
        }
        .padding()
        .frame(width: 800, height: 600)
        .onAppear {
            setupNotifications()
            updateAndCorrect()
        }
    }
    
    private func setupNotifications() {
        let cancellable = NotificationCenter.default
            .publisher(for: .serviceActivated)
            .sink(receiveValue: handleNotification(note:))
        
        let anotherCancellable = NotificationCenter.default
            .publisher(for: .orderedFront)
            .sink(receiveValue: handleOrderedFrontNotification(note:))
        
        cancellables.insert(cancellable)
        cancellables.insert(anotherCancellable)
    }
    
    private func updateAndCorrect() {
        Task.detached(priority: .background) {
            await viewModel.findSelectedText()
            
            if await viewModel.correctedText.isEmpty {
                try await viewModel.correctText()
            }
        }
    }
    
    private func solicitAPIKey() {
        openSettings()
    }
    
    private func handleNotification(note: Notification) {
        guard let selectedText = note.userInfo?[Notification.selectedTextKey] as? String else {
            return
        }
        
        viewModel.textForCorrection = selectedText
        
        Task {
            try await viewModel.correctText()
        }
    }
    
    private func handleOrderedFrontNotification(note: Notification) {
        updateAndCorrect()
    }

}
