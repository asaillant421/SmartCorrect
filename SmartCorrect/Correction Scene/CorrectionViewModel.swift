//
//  CorrectionViewModel.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 13/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import Combine

@Observable
class CorrectionViewModel {
    var shouldSaveAdditionalInstructions = false
    private let apiKey: String
    
    var textForCorrection = ""
    var correctedText = ""
    var additionalInstructions = ""
    
    private var cancellables: Set<AnyCancellable> = []
    private let service: CorrectionService
    
    init(apiKey: String) {
        self.apiKey = apiKey
        service = CorrectionService(apiKey: apiKey)
        let cancellable = NotificationCenter.default.publisher(for: Notification.serviceActivated)
            .sink(receiveValue: handleNotification(note:))
        
        cancellables.insert(cancellable)
    }
    
    func correctText() async throws {
        correctedText = try await service.fetchCorrection(for: textForCorrection, prompt: "mainPrompt")
    }
    
    func improveCorrection(withModifications extraInstructions: String? = nil) async throws {
        let additional = extraInstructions ?? additionalInstructions
        correctedText = try await service.fetchCorrection(for: correctedText, prompt: "secondaryPrompt", additionalInstructions: additional)
    }
    
    private func handleNotification(note: Notification) {
        guard let selectedText = note.userInfo?[Notification.selectedTextKey] as? String else {
            return
        }
        
        self.textForCorrection = selectedText
        
        Task {
            try await correctText()
        }
    }
}
