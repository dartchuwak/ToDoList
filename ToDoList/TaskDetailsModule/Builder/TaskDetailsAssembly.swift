//
//  TaskDetailsAssembly.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation

import Foundation
import UIKit

class TaskDetailsAssembly {
    static func build(with task: TaskModel) -> UIViewController {
        let view = TaskDetailsViewController()
        let presenter = TaskDetailsPresenter(task: task)
        let interactor = TaskDetailsInteractor()
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