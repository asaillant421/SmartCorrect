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

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        testValue = "Floopus"
        #expect(testValue == "Floopus")
        secondTestValue = testValue
        #expect(secondTestValue == "Floopus")
    }

}
