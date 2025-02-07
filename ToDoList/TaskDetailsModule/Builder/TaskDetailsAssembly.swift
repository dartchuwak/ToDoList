//
//  TaskDetailsAssembly.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import Foundation

import Foundation
import UIKit

final class TaskDetailsAssembly {
    static func build(with task: TaskModel) -> UIViewController {
        let view = TaskDetailsViewController()
        let presenter = TaskDetailsPresenter(task: task)
        let coreData = CoreDataStack(modelName: "DoToList")
        let coreDataManager = CoreDataManager(coreDataStack: coreData)
        let interactor = TaskDetailsInteractor(coreDataManager: coreDataManager)
        let router = TaskDetailsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.vc = view
        
        let vc = view
        return vc
    }
}
