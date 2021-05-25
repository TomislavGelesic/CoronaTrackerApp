
import UIKit
import Combine
import CoreLocation

class HomeScreenViewModel: NSObject, ErrorableViewModel, LoaderViewModel {
    
    var coordinator: HomeScreenCoordinatorImpl?
    var repository: Covid19Repository
    var screenData = HomeScreenDomainItem()
    var loaderPublisher = CurrentValueSubject<Bool, Never>(true)
    var errorSubject = PassthroughSubject<ErrorType?, Never>()
    var updateScreenSubject = PassthroughSubject<Bool, Never>()
    var fetchScreenDataSubject = PassthroughSubject<UseCaseSelection, Never>()
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
    
    func initializeFetchScreenDataSubject(_ subject: PassthroughSubject<UseCaseSelection, Never>) -> AnyCancellable {
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
        return Publishers.Zip(repository.getCountryStats(for: countryName),
                              repository.getCountryStatsTotal(for: countryName))
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
                let newScreenData = self.createScreenData(from: totalData, and: dayOneData)
                return self.createSuccessPublisher(newScreenData)
            }.eraseToAnyPublisher()
    }
    
    func getWorldwideData() -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> {
        return repository.getWorldwideData()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .flatMap { (result) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> in
                switch result {
                case .success(let worldwideResponse):
                    let newScreenData: HomeScreenDomainItem = self.createScreenData(from: worldwideResponse)
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
    
    func createScreenData(from totalStats: [CountryResponseItem], and dayOneStats: [CountryResponseItem]) -> HomeScreenDomainItem {
        var screenData = HomeScreenDomainItem()
        if totalStats.count > 2,
            dayOneStats.count > 2 {
            
            let lastTwoTotalStats = totalStats.suffix(2) as Array
            let totalStatsSecondToLast = lastTwoTotalStats[0]
            let totalStatsLast = lastTwoTotalStats[1]
            
            screenData.title = totalStatsLast.country
            screenData.confirmedTotalCount = totalStatsLast.confirmed
            screenData.confirmedDifferenceCount = totalStatsLast.confirmed - totalStatsSecondToLast.confirmed
            screenData.activeTotalCount = totalStatsLast.active
            screenData.activeDifferenceCount = totalStatsLast.active - totalStatsSecondToLast.active
            screenData.recoveredTotalCount = totalStatsLast.recovered
            screenData.recoveredDifferenceCount = totalStatsLast.recovered - totalStatsSecondToLast.recovered
            screenData.deathsTotalCount = totalStatsLast.deaths
            screenData.deathsDifferenceCount = totalStatsLast.deaths - totalStatsSecondToLast.deaths
            screenData.details = createDetails(from: dayOneStats)
            screenData.lastUpdateDate = Date()
        }
        return screenData
    }
    
    func createScreenData(from item: WorldwideResponseItem) -> HomeScreenDomainItem {
        var screenData = HomeScreenDomainItem()
        screenData.title = "Worldwide"
        screenData.confirmedTotalCount = item.global.totalConfirmed
        screenData.confirmedDifferenceCount = item.global.newConfirmed
        screenData.recoveredTotalCount = item.global.totalRecovered
        screenData.recoveredDifferenceCount = item.global.newRecovered
        screenData.deathsTotalCount = item.global.totalDeaths
        screenData.deathsDifferenceCount = item.global.newDeaths
        screenData.activeTotalCount = screenData.confirmedTotalCount - screenData.recoveredTotalCount
        screenData.activeDifferenceCount = screenData.confirmedDifferenceCount - screenData.recoveredDifferenceCount
        screenData.details = createDetails(from: item.countries)
        screenData.lastUpdateDate = Date()
        return screenData
    }
    
    func createDetails(from responseItems: [CountryResponseItem]) -> [HomeScreenDomainItemDetail] {
        var newDetails = [HomeScreenDomainItemDetail]()
        let filteredResponseItems = responseItems.filter({ $0.province == "" })
        for (index, currentItem) in filteredResponseItems.enumerated() {
            if index == 0 {
                var newItem = HomeScreenDomainItemDetail()
                newItem.title = DateUtils.getDomainDetailItemDate(from: currentItem.date) ?? ""
                newItem.confirmed = currentItem.confirmed
                newItem.recovered = currentItem.recovered
                newItem.deaths = currentItem.deaths
                newItem.active = currentItem.active
                newDetails.append(newItem)
            }
            else {
                let previousItem = filteredResponseItems[index - 1]
                var newItem = HomeScreenDomainItemDetail()
                newItem.title = DateUtils.getDomainDetailItemDate(from: currentItem.date) ?? ""
                newItem.confirmed = currentItem.confirmed - previousItem.confirmed
                newItem.recovered = currentItem.recovered - previousItem.recovered
                newItem.deaths = currentItem.deaths - previousItem.deaths
                newItem.active = currentItem.active - previousItem.active
                newDetails.append(newItem)
            }
        }
        return newDetails.reversed() as Array
    }
    
    func createDetails(from responseItems: [CountryStatus]) -> [HomeScreenDomainItemDetail] {
        var newDetails = [HomeScreenDomainItemDetail]()
        for responseItem in responseItems {
            var item = HomeScreenDomainItemDetail()
            item.title = responseItem.countryName
            item.confirmed = responseItem.totalConfirmed
            item.recovered = responseItem.totalRecovered
            item.deaths = responseItem.totalDeaths
            item.active = responseItem.totalConfirmed - responseItem.totalRecovered
            newDetails.append(item)
        }
        return newDetails.sorted { $0.confirmed > $1.confirmed }
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
