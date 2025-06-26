//
//  ResponsesAPIResponse.swift
//  SmartCorrect
//
//  Created by ChatGPT on 25/06/2025.
//


import Foundation

struct ResponsesAPIResponse: Codable {
    let id: String
    let object: String
    let createdAt: TimeInterval
    let model: String
    let error: APIError?
    let instructions: String?
    let metadata: [String: String]?
    let output: [OutputMessage]
    let outputText: String?
    let status: String
    let usage: Usage?
    let previousResponseId: String?
    let temperature: Double?
    let topP: Double?
    let toolChoice: String?
    let tools: [Tool]?
    let reasoning: Reasoning?
    let truncation: String?
    // Add more fields as needed

    enum CodingKeys: String, CodingKey {
        case id, object
        case createdAt = "created_at"
        case model, error, instructions, metadata, output
        case outputText = "output_text"
        case status, usage
        case previousResponseId = "previous_response_id"
        case temperature, topP = "top_p"
        case toolChoice = "tool_choice"
        case tools, reasoning, truncation
    }

    // Nested types
    struct OutputMessage: Codable {
        let id: String
        let role: String
        let content: [Content]
        let status: String?
        let type: String

        struct Content: Codable {
            let type: String
            let text: String?
            let annotations: [Annotation]?

            struct Annotation: Codable {
                let type: String
                let start: Int?
                let end: Int?
                let title: String?
                // add more if detailed annotations exist
            }
        }
    }

    struct Usage: Codable {
        let inputTokens: Int
        let outputTokens: Int
        let totalTokens: Int
        let outputTokensDetails: OutputTokensDetails?

        enum CodingKeys: String, CodingKey {
            case inputTokens = "input_tokens"
            case outputTokens = "output_tokens"
            case totalTokens = "total_tokens"
            case outputTokensDetails = "output_tokens_details"
        }

        struct OutputTokensDetails: Codable {
            let reasoningTokens: Int?

            enum CodingKeys: String, CodingKey {
                case reasoningTokens = "reasoning_tokens"
            }
        }
    }

    struct Tool: Codable {
        let type: String
        let name: String?
        let description: String?
        let parameters: [String: AnyCodable]?
    }

    struct Reasoning: Codable {
        let effort: String?
        let summary: String?
        let encryptedContent: String?

        enum CodingKeys: String, CodingKey {
            case effort, summary
            case encryptedContent = "encrypted_content"
        }
    }
}

// Support for arbitrary JSON values in Tool.parameters
struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            value = intVal
        } else if let dblVal = try? container.decode(Double.self) {
            value = dblVal
        } else if let boolVal = try? container.decode(Bool.self) {
            value = boolVal
        } else if let strVal = try? container.decode(String.self) {
            value = strVal
        } else if let dictVal = try? container.decode([String: AnyCodable].self) {
            value = dictVal.mapValues { $0.value }
        } else if let arrVal = try? container.decode([AnyCodable].self) {
            value = arrVal.map { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                debugDescription: "Cannot decode AnyCodable")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let v as Int: try container.encode(v)
        case let v as Double: try container.encode(v)
        case let v as Bool: try container.encode(v)
        case let v as String: try container.encode(v)
        case let dict as [String: Any]:
            let encodableDict = dict.mapValues { AnyCodable($0) }
            try container.encode(encodableDict)
        case let arr as [Any]:
            let encodableArr = arr.map { AnyCodable($0) }
            try container.encode(encodableArr)
        default:
            let context = EncodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "AnyCodable value cannot be encoded"
            )
            throw EncodingError.invalidValue(value, context)
        }
    }
}
