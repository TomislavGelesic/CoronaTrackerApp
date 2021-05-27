
import UIKit
import Combine
import CoreLocation

class HomeScreenViewModel: NSObject, ErrorableViewModel, LoaderViewModel {
    
    var coordinator: HomeScreenCoordinatorImpl?
    var repository: Covid19Repository
    var screenData: HomeScreenDomainItem = .init()
    var loaderPublisher = CurrentValueSubject<Bool, Never>(true)
    var errorSubject = PassthroughSubject<ErrorType?, Never>()
    var updateScreenSubject = PassthroughSubject<Bool, Never>()
    var fetchScreenDataSubject = CurrentValueSubject<UseCaseSelection, Never>(.country("croatia"))
    var locationManager: CLLocationManager
    
    init(repository: Covid19Repository) {
        self.repository = repository
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    deinit { print("HomeScreenViewModel deinit called.") }
}

extension HomeScreenViewModel {
    
    func changeUsecaseSelection() { coordinator?.openCountrySelection() }
    
    func initializeFetchScreenDataSubject(_ subject: CurrentValueSubject<UseCaseSelection, Never>) -> AnyCancellable {
        subject
            .flatMap { [unowned self] (usecase) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> in
                self.loaderPublisher.send(true)
                return self.getData(usecase)
            }            
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (result) in
                self.handleResult(result)
            }
    }
    
    func getData(_ usecase: UseCaseSelection) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> {
        switch usecase {
        case .country(let countryName):
            UserDefaultsService.update(.init(usecase: countryName))
            return getCountryData(name: countryName)
        case .worldwide:
            UserDefaultsService.update(.init(usecase: "worldwide"))
            return getWorldwideData()
        }
    }
    
    func getCountryData(name countryName: String) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> {
        return Publishers.Zip(repository.getCountryStatsTotal(for: countryName),
                              repository.getCountryStats(for: countryName))
            .flatMap { (totalResponse, dayOneResponse ) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> in
                var totalData = [CountryResponseItem]()
                var dayOneData = [CountryResponseItem]()
                switch totalResponse {
                case .success(let data): totalData = data
                case .failure(let error): return self.createFailurePublisher(error)
                }
                switch dayOneResponse {
                case .success(let data): dayOneData = data
                case .failure(let error): return self.createFailurePublisher(error)
                }
                let newScreenData = self.createCountryScreenData(from: totalData, and: dayOneData)
                return self.createSuccessPublisher(newScreenData)
            }.eraseToAnyPublisher()
    }
    
    func getWorldwideData() -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> {
        return repository.getWorldwideData()
            .flatMap { (result) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> in
                switch result {
                case .success(let worldwideResponse):
                    let newScreenData: HomeScreenDomainItem = self.createWorldwideScreenData(from: worldwideResponse)
                    return self.createSuccessPublisher(newScreenData)
                case .failure(let error):
                    return self.createFailurePublisher(error)
                }
            }.eraseToAnyPublisher()
    }
    
    func handleResult(_ result: Result<HomeScreenDomainItem, ErrorType>) {
        switch result {
        case .success(let item):
            UserDefaultsService.update(.init(usecase: item.title))
            screenData = item
            updateScreenSubject.send(true)
            handleError(nil)
        case .failure(let error):
            handleError(error)
        }
        loaderPublisher.send(false)
    }
    
    func createCountryScreenData(from totalStats: [CountryResponseItem], and dayOneStats: [CountryResponseItem]) -> HomeScreenDomainItem {
        return HomeScreenDomainItem(totalStatsResponse: totalStats, dayOneStatsResponse: dayOneStats)
    }
    
    func createWorldwideScreenData(from item: WorldwideResponseItem) -> HomeScreenDomainItem {
        return HomeScreenDomainItem(item)
    }
    
    func createSuccessPublisher(_ data: HomeScreenDomainItem) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> {
        return Just<Result<HomeScreenDomainItem, ErrorType>>(.success(data)).eraseToAnyPublisher()
    }
    
    func createFailurePublisher(_ error: ErrorType) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> {
        return Just<Result<HomeScreenDomainItem, ErrorType>>(.failure(error)).eraseToAnyPublisher()
    }
}

extension HomeScreenViewModel: CountrySelectionHandler {
    func openCountrySelection() { coordinator?.openCountrySelection() }
}

extension HomeScreenViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if let locationExists = locationManager.location {
                CLGeocoder().reverseGeocodeLocation(locationExists) { [unowned self] placemarks, error in
                    guard let countryName: String = placemarks?.first?.country,
                          error == nil else { return }
                    self.fetchScreenDataSubject.send(.country(StringUtils.createSlug(from: countryName)))
                }
            }
        case .notDetermined:
            loaderPublisher.send(true)
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            fetchScreenDataSubject.send(UserDefaultsService.getUsecase())
        default: break
        }
    }
}
