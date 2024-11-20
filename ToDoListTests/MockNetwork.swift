//
//  MockNetwork.swift
//  ToDoListTests
//
//  Created by Evgenii Mikhailov on 20.11.2024.
//

import Foundation

// Мок для NetworkServiceProtocol
class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError: Bool = false
    var mockData: Data?
    var mockError: Error?
    
    func fetchData(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(mockError ?? NSError(domain: "MockError", code: -1, userInfo: nil)))
        } else {
            completion(.success(mockData ?? Data()))
        }
    }
}
