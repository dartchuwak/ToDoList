//
//  API.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData(url: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "URLError", code: -1, userInfo: nil)))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
