//
//  OpenAIResponse.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/14.
//

import Foundation

// MARK: - Openai
class OpenAIResponse: Codable {
    let created: Int?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let url: String?
}

// MARK: - Generic 응답처리
struct BaseListResponse<T: Codable>: Codable {
    let created: Int?
    let data: [T]?
}

struct BaseResponse<T: Codable>: Codable {
    let url: T?
}
