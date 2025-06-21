//
//  ChatGPTService.swift
//  ExpenseTracker
//
//  Created by Swapnil on 01/12/24.
//

import Foundation
class ChatGPTService {
    private let url = URL(string: "https://api.openai.com/v1/completions")!
    let apiKey = ""
    private let networkManager: Networking
     
    // Dependency Injection
    init(networkManager: Networking = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func sendMessage<T: Decodable>(message: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        var request = createRequest(message: message)
        
        networkManager.performRequest(urlRequest: request) { (result: Result<T, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendMessage(message: String, completion: @escaping (String?) -> Void) {
            let parameters: [String: Any] = [
                "model": "gpt-3.5-turbo",
                "messages": [
                    ["role": "system", "content": "You are a helpful assistant."],
                    ["role": "user", "content": message]
                ]
            ]

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                print("Error encoding JSON: \(error)")
                completion(nil)
                return
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making request: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received")
                    completion(nil)
                    return
                }

                // Print the raw response data to debug
                if let rawResponse = String(data: data, encoding: .utf8) {
                    print("Raw response: \(rawResponse)")
                }

                do {
                    // Decode the response
                    let responseModel = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
                    let messageContent = responseModel.choices.first?.message.content
                    completion(messageContent)
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(nil)
                }
            }

            task.resume()
        }
    
    private func createRequest(message: String) -> URLRequest {
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": message]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            fatalError("Failed to encode request body: \(error)")
        }
        
        return request
    }
}

struct ChatGPTResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
    let finish_reason: String
    let index: Int
}

struct Message: Codable {
    let role: String
    let content: String
}
