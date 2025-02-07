//
//  TaskDetailsRouter.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import Foundation
import UIKit

protocol TaskDetailsRouterProtocol {
    func navigateBack()
}

final class TaskDetailsRouter: TaskDetailsRouterProtocol {
    weak var vc: UIViewController?
    
    func navigateBack() {
        vc?.navigationController?.popViewController(animated: true)
    }
}
