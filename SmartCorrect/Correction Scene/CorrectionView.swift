//
//  CorrectionView.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 12/06/2025.
//  Copyright © 2025 Entopia Investment Inc. All rights reserved.
//

import SwiftUI

struct CorrectionView : View {
    @AppSecureStorage("apiKey") private var apiKey: String?
    @State private var viewModel: CorrectionViewModel?
    @AppStorage("mainPrompt") private var mainPrompt = Constants.defaultMainPrompt
    @AppStorage("secondaryPrompt") private var secondaryPrompt = Constants.defaultSecondaryPrompt
    @AppStorage("textForCorrection") private var textForCorrection = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Improve Writing", systemImage: "sparkles")
            
            Group {

                if let viewModel {
                    CorrectionEditorView(viewModel: viewModel)
                }
            }
            
            HStack {
                Button("Make more formal") {
                    // TODO
                }
                
                Button("Use more humor") {
                    // TODO
                }
            }
            
                Group {
                    if let viewModel {
                        CorrectionButtonFooterView(viewModel: viewModel)
                    }
                
                }
            
        }
        .onAppear {
            if nil == viewModel, let apiKey {
                viewModel = CorrectionViewModel(apiKey: apiKey, text: textForCorrection, mainPrompt: mainPrompt, secondaryPrompt: secondaryPrompt)
            }
        }
        .onDisappear {
            viewModel = nil
        }
        .padding()
    }
    
    init(text: String) {
        textForCorrection = text
    }
}
