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
        let apiKey = #require(apiKey, "API key not set")
        #expect(!apiKey.isEmpty)
        
        
    }
}
