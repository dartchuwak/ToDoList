//
//  Assembly.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation
import UIKit

class MainAssembly {
    static func build() -> UIViewController {
        let view = MainScreenView()
        let presenter = MainScreenPresenter()
        let interactor = MainScreenInteractor()
        let router = MainScreenRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.vc = view
        
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
}
