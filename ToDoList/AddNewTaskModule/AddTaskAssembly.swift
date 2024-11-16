//
//  AddTaskAssembly.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation
import UIKit

final class AddNewTaskAssembly {
    static func build() -> UIViewController {
        let view = AddNewTaskScreenViewController()
        let presenter = AddNewTaskPresenter()
        let interactor = AddNewTaskInteractor()
        let router = AddNewTaskRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.vc = view
        
        
        
        return view
    }
}
