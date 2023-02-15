//
//  SearchAPI.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/14.
//

import Foundation

enum SearchAPI {
    static let baseURL = "https://api.openai.com/v1/images/generations"
    
    static let APIkey = "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"
    
    enum ApiError: Error {
        case badStatus(code: Int)
        case decodingError
        case jsonEncoding
        case noContent
        case notAllowedURL
        case unknown(_ error: Error?)
        
        var info: String {
            switch self {
            case let .badStatus(code): return "에러 상태코드: \(code)입니다."
            case .decodingError: return "decoding 에러입니다."
            case .jsonEncoding: return "유효한 json형식이 아닙니다."
            case .noContent: return "데이터가 없습니다."
            case .notAllowedURL: return "잘못된 URL경로입니다."
            case .unknown(let error): return "알 수 없는 \(String(describing: error)): 에러입니다."
            }
        }
    }
}

// Search API
// - Parameters: prompt = 검색어
//               n = 그림의 숫자
//               size: 사이즈
// - completion: 응답결과 = url형식의 <datum> 또는 ApiError
extension SearchAPI {
    static func searchSketch(prompt: String,
                             n: Int,
                             size: String,
                             completion: @escaping (Result<BaseListResponse<Datum>, ApiError>) -> Void) {
        
        let urlString = baseURL
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(APIkey)", forHTTPHeaderField: "Authorization")
        
        guard let bodyData = "{\"prompt\": \"\(prompt) sketch with white background\", \"n\": \(n), \"size\": \"\(size)\"}".data(using: .utf8)
              else { return }
        
        urlRequest.httpBody = bodyData
        
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(error)))
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct 로 변경 즉 디코딩 즉 데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Datum>.self, from: jsonData)
                    let imageUrls = listResponse.data
                    
                    // 상태 코드는 200인데 파싱한 데이터에 따라서 에러처리
                    guard let imageUrls = imageUrls,
                          !imageUrls.isEmpty else {
                        return completion(.failure(ApiError.noContent))
                    }
                    
                    completion(.success(listResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
        
    }
}
