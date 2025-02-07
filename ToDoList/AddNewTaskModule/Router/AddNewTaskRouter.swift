//
//  AddNewTaskRouter.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import Foundation
import UIKit

protocol AddNewTaskRouterProtocol {
    func navigateBack()
}

final class AddNewTaskRouter: AddNewTaskRouterProtocol {
    weak var vc: UIViewController?
    
    func navigateBack() {
        vc?.navigationController?.popViewController(animated: true)
    }
}
