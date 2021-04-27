//
//  CountrySelectionViewModel.swift
//  CoronaVirusApp
//
//  Created by Ivan Simunovic on 12.04.2021..
//

import UIKit

class CountrySelectionCoordinator: Coordinator {
    var parent: ParentCoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    let controller: CountrySelectionViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.controller = CountrySelectionCoordinator.createController()
    }
}

extension CountrySelectionCoordinator {
    
    func start() {
        navigationController.pushViewController(controller, animated: false)
    }
}

private extension CountrySelectionCoordinator {
    static func createController() -> CountrySelectionViewController {
        let repository = Covid19RepositoryImpl()
        let viewModel = CountrySelectionViewModel(repository: repository)
        viewModel.coordinatorDelegate = self
        let viewController = CountrySelectionViewController(viewModel: viewModel)
        return viewController
    }
}

extension CountrySelectionCoordinator: CoordinatorDelegate {
    func viewControllerDidFinish() {
        parent?.childDidFinish(self)
    }
}
