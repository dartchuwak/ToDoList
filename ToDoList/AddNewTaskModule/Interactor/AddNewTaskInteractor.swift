//
//  AddNewTaskInteractor.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation
import UIKit
import CoreData

protocol AddNewTaskInteractorProtocol: AnyObject {
    func saveTask(title: String, description: String)
}

final class AddNewTaskInteractor: AddNewTaskInteractorProtocol {
    weak var presenter: AddNewTaskPresenterProtocol?
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func saveTask(title: String, description: String) {
        coreDataManager.saveTask(title: title, description: description) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.presenter?.didSaveTask()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.didFailToSaveTask(error: error.localizedDescription)
                }
            }
        }
    }
}
