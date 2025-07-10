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
    private let clipboardService = ClipboardService()
    
    init(apiKey: String) {
        self.apiKey = apiKey
        service = CorrectionService(apiKey: apiKey)
        let cancellable = NotificationCenter.default.publisher(for: Notification.serviceActivated)
            .sink(receiveValue: handleNotification(note:))
        
        cancellables.insert(cancellable)
    }
    
    func findSelectedText() async {
        guard textForCorrection.isEmpty else { return }
        
        if let text = await clipboardService.findSelectedText() {
            textForCorrection = text
        }
        
    }
    
    func correctText() async throws {
        if additionalInstructions.isEmpty {
            correctedText = try await service.fetchCorrection(for: textForCorrection)
        } else {
            try await improveCorrection(withModifications: additionalInstructions)
        }
    }
    
    func pasteCorrection() async {
        
        await clipboardService.replaceSelectedText(with: correctedText)
    }
    
    func improveCorrection(withModifications extraInstructions: String? = nil) async throws {
        let additional = extraInstructions ?? additionalInstructions
        
        let modifiedPrompt = Constants.defaultSecondaryPrompt.replacingOccurrences(of: Constants.defaultSecondaryPromptInstructionPlaceholder, with: additional)
        
        correctedText = try await service.fetchCorrection(for: correctedText, prompt: modifiedPrompt)
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
    
    //
    
}
