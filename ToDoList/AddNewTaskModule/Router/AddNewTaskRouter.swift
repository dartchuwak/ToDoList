//
//  AddNewTaskRouter.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
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
