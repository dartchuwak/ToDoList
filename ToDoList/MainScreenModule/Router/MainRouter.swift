//
//  Router.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import Foundation
import UIKit

protocol MainScreenRouterProtocol: AnyObject {
    func navigateToAddNewTaskScreen()
    func navigateToTaskDetails(with: TaskModel)
}

final class MainScreenRouter: MainScreenRouterProtocol {
    weak var vc: UIViewController?
    
    func navigateToAddNewTaskScreen() {
        let viewController = AddNewTaskAssembly.build()
        vc?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToTaskDetails(with task: TaskModel) {
        let detailsViewController = TaskDetailsAssembly.build(with: task)
        vc?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
