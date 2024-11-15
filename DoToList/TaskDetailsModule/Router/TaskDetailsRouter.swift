//
//  TaskDetailsRouter.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
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
