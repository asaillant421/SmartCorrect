//
//  CorrectionViewModel.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 13/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import Combine
import SwiftData
import AppKit

@Observable
class CorrectionViewModel {
    var shouldSaveAdditionalInstructions = false
    private let apiKey: String
    private var mainPrompt: Prompt?
    
    var textForCorrection = "" {
        didSet {
            guard textForCorrection != oldValue else { return }
            
            correctedText = ""
        }
    }
    var correctedText = ""
    var additionalInstructions = ""
    var sourceAppName: String = ""
    var sourceAppIcon: NSImage?
    
    private let service: CorrectionService
    private let textService = TextSelectionService()
    
    init(apiKey: String, modelContext: ModelContext) {
        self.apiKey = apiKey
        service = CorrectionService(apiKey: apiKey, modelContext: modelContext)
        fetchMainPrompt(from: modelContext)
    }
    
    func findSelectedText() async {
        guard let text = await textService.findSelectedText(), text != textForCorrection else { 
            // Update source app info even if text hasn't changed
            await updateSourceAppInfo()
            return 
        }
        
        print("New text is \(text)")
        textForCorrection = text
        await updateSourceAppInfo()
//        correctedText = ""
        print("New corrected text is \(correctedText)")
    }
    
    private func updateSourceAppInfo() async {
        sourceAppName = await textService.selectedTextSource ?? ""
        
        // Get the bundle ID to find the app icon
        if let bundleID = await getBundleID() {
            sourceAppIcon = getAppIcon(for: bundleID)
        } else {
            sourceAppIcon = nil
        }
    }
    
    private func getBundleID() async -> String? {
        // Access the bundle ID from TextSelectionService
        // We need to get this from the service since it has the previousBundleID
        return await textService.getBundleID()
    }
    
    private func getAppIcon(for bundleID: String) -> NSImage? {
        guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID).first else {
            return nil
        }
        return app.icon
    }
    
    func correctText() async throws {
        let promptText = mainPrompt?.text ?? Constants.defaultMainPrompt
        let originatingApp = await textService.selectedTextSource ?? ""
        if additionalInstructions.isEmpty {
            correctedText = try await service.fetchCorrection(for: textForCorrection, in: originatingApp, prompt: promptText)
        } else {
            try await improveCorrection(withModifications: additionalInstructions)
        }
    }
    
    func correctText(prompt: String) async throws {
        let originatingApp = await textService.selectedTextSource ?? ""
        correctedText = try await service.fetchCorrection(for: textForCorrection, in: originatingApp, prompt: prompt)
    }
    
    func pasteCorrection() async {
        
        await textService.replaceSelectedText(with: correctedText)
    }
    
    func improveCorrection(withModifications extraInstructions: String? = nil) async throws {
        let originatingApp = await textService.selectedTextSource ?? ""
        correctedText = try await service.fetchCorrection(for: correctedText, in: originatingApp, prompt: extraInstructions ?? additionalInstructions)
    }
     
    private func fetchMainPrompt(from context: ModelContext) {
        var descriptor = FetchDescriptor<Prompt>()
        descriptor.predicate = #Predicate<Prompt> { $0.shouldShowButton == false }
        descriptor.fetchLimit = 1
        
        do {
            mainPrompt = try context.fetch(descriptor).first
        } catch {
            print("Failed to fetch main prompt: \(error)")
            mainPrompt = nil
        }
    }
    
    //
    
}
