//
//  NetworkManager.swift
//  ExpenseTracker
//
//  Created by Swapnil on 01/12/24.
//

import Foundation
import Foundation

protocol Networking {
    func performRequest<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager: Networking {
    func performRequest<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
