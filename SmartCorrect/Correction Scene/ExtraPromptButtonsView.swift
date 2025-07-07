//
//  ExtraPromptButtonsView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 23/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI
import SwiftData

struct ExtraPromptButtonsView : View {
    @Query var prompts: [Prompt]
    @Bindable var viewModel: CorrectionViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(prompts) { prompt in
                    Button(prompt.name) {
                        Task.detached(priority: .background) {
                            do {
                                try await self.viewModel.improveCorrection(withModifications: prompt.text)
                            } catch {
                                // TODO
                            }
                        }
                    }
                }
            }
        }
    }
}
