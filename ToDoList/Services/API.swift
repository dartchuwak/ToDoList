//
//  API.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation

protocol APIProtocol {
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void)
}

final class API: APIProtocol {
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        let url = URL(string: "https://dummyjson.com/todos")!
        // Выполняем запрос в фоновом потоке
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
