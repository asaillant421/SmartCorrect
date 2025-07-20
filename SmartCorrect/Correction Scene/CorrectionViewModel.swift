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
    private let textService = TextSelectionService()
    
    init(apiKey: String) {
        self.apiKey = apiKey
        service = CorrectionService(apiKey: apiKey)
        let cancellable = NotificationCenter.default.publisher(for: .serviceActivated)
            .sink(receiveValue: handleNotification(note:))
        
        let anotherCancellable = NotificationCenter.default
            .publisher(for: .orderedFront)
            .sink(receiveValue: handleOrderedFrontNotification(note:))
        
        cancellables.insert(cancellable)
        cancellables.insert(anotherCancellable)
    }
    
    func findSelectedText() async {
        if let text = await textService.findSelectedText() {
//            if text != textForCorrection {
                textForCorrection = text
                correctedText = ""
//            } else {
                print("New text is \(text)")
//            }
        } else {
            print("No selected text found")
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
        
        await textService.replaceSelectedText(with: correctedText)
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
    
    private func handleOrderedFrontNotification(note: Notification) {
            Task.detached(priority: .background) { [weak self] in
                
                await self?.findSelectedText()
                
                if let welf = self, welf.correctedText.isEmpty {
                    try await welf.correctText()
                }
            }
    }
    
    //
    
}
