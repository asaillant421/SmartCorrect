//
//  SmartCorrectTests.swift
//  SmartCorrectTests
//
//  Created by מאיר רדנוביץ׳ on 08/06/2025.
//

import Testing
@testable import SmartCorrect

struct SmartCorrectTests {
    @AppSecureStorage("testValue") var testValue: String?
    @AppSecureStorage("secondTestValue") var secondTestValue: String?
    @AppSecureStorage("apiKey") var apiKey: String?

    @Test func savesToKeychain() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        testValue = "Floopus"
        #expect(testValue == "Floopus")
        secondTestValue = testValue
        #expect(secondTestValue == "Floopus")
    }

    @Test func responsesAPICall() async throws {
        let apiKey = try #require(apiKey, "API key not set")
        #expect(!apiKey.isEmpty)
        
        let req = ResponsesAPIRequest(model: .gpt35turbo, input: Constants.defaultMainPrompt + "\n\nTeh snappy innerface of macos 26 taheo is mahvelous to use and behold. Butt, the liqid glass isn't my cup of tea.")
        
        let response: ResponsesAPIResponse = try await APIManager.shared.sendRequest(endpoint: .responses, params: req, authToken: "Bearer \(apiKey)")
        
        let outputText = try #require(response.output.first?.content.first?.text, "No output text")
        #expect(!outputText.isEmpty)
    }
    
    @Test func fetchCorrections() async throws {
        let apiKey = try #require(apiKey, "API key not set")
        #expect(!apiKey.isEmpty)
        
        let service = CorrectionService(apiKey: apiKey, model: .gpt35turbo)
        
        let improvedVersion = try await service.fetchCorrection(for: "I just received message the boys are now going swimming and can not call tonight Please try to have them call me tonight and tomorrow before shabbos!! In future message me first and give me time to call")
        
        #expect(!improvedVersion.isEmpty)
    }
}
