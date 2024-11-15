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
                // Получаем данные с URL
                let data = try Data(contentsOf: url)
                
                // Возвращаемся в главный поток для обновления UI или вызова completion
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } catch {
                // Обрабатываем ошибку и возвращаемся в главный поток
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
