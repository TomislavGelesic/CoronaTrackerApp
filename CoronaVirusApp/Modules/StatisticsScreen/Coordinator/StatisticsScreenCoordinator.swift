
import UIKit
import MapKit

class StatisticsScreenCoordinator: Coordinator {
    
    weak var parent: (ParentCoordinatorDelegate & CountrySelectionHandler)?
    var childCoordinators: [Coordinator] = .init()
    var presenter: UINavigationController
    var controller: StatistiscScreenViewController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.controller = StatisticsScreenCoordinator.createController()
        controller.viewModel.coordinator = self
    }
    
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    static func createController() -> StatistiscScreenViewController {
        let viewModel = StatisticsScreenViewModel(repository: Covid19RepositoryImpl())
        let controller = StatistiscScreenViewController(viewModel: viewModel)
        return controller
    }
}

extension StatisticsScreenCoordinator: StatisticsScreenCoordinatorDelegate {
    func openInAppleMaps(_ mapItem: MKMapItem, showing region: MKCoordinateRegion) {
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
        ]
        mapItem.openInMaps(launchOptions: options)
    }
    
    func openCountrySelection() {
        parent?.openCountrySelection()
    }
}
