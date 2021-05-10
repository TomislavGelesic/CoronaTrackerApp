
import UIKit
import Combine
import CoreLocation

class HomeScreenViewModel: ErrorableViewModel, LoaderViewModel {
    
    var coordinator: HomeScreenCoordinatorImpl?
    weak var viewControllerDelegate: HomeScreenViewController?
    var repository: Covid19Repository
    var screenData = HomeScreenDomainItem()
    var usecase: UseCaseSelection?
    var loaderPublisher = PassthroughSubject<Bool, Never>()
    var errorSubject = PassthroughSubject<ErrorType?, Never>()
    var updateScreenSubject = CurrentValueSubject<Bool, Never>(true)
    var fetchScreenDataSubject = PassthroughSubject<Void, Never>()
    var loaderIsVisible = false
    init(repository: Covid19Repository) {
        self.repository = repository
    }
    deinit { print("HomeScreenViewModel deinit called.") }
    
}

extension HomeScreenViewModel {
    
    func getData(using locationManager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .denied, .restricted:
                getData()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                locationManager.startUpdatingLocation()
            }
        }
        else {
            handleError(.noInternet)
        }
    }
    
    func getData() {
        guard let savedUsecase = UserDefaultsService.getUsecase()
        else {
            getDefaultData()
            return
        }
        self.usecase = savedUsecase
        fetchScreenDataSubject.send()
    }
    
    func getDefaultData() {
        self.usecase = .country("croatia")
        fetchScreenDataSubject.send()
    }
    
    func changeUsecaseSelection() { coordinator?.openCountrySelection() }
    
    func initializeFetchScreenDataSubject(_ subject: AnyPublisher<Void, Never>) -> AnyCancellable {
        subject
            .flatMap { [unowned self] (_) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> in
                guard let usecase = UserDefaultsService.getUsecase() else { return self.createFailurePublisher(.general) }
                //                if !loaderIsVisible {
                //                    self.loaderIsVisible = true
                //                    self.loaderPublisher.send(true)
                //                }
                self.usecase = usecase
                switch usecase {
                case .country(let countryName):
                    let dayOneStatsPublisher: AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never> = repository.getCountryStats(for: countryName)
                    let totalStatsPublisher: AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never> = repository.getCountryStatsTotal(for: countryName)
                    return Publishers.Zip(totalStatsPublisher, dayOneStatsPublisher)
                        .flatMap { (totalResponse, dayOneResponse ) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> in
                            var totalData = [CountryResponseItem]()
                            var dayOneData = [CountryResponseItem]()
                            switch totalResponse {
                            case .success(let data):
                                if data.isEmpty { return self.createFailurePublisher(.general) }
                                totalData = data
                            case .failure(let error):
                                return self.createFailurePublisher(error)
                            }
                            switch dayOneResponse {
                            case .success(let data):
                                if data.isEmpty { return self.createFailurePublisher(.general) }
                                dayOneData = data
                            case .failure(let error):
                                return self.createFailurePublisher(error)
                            }
                            let newScreenData = createScreenData(from: totalData, and: dayOneData)
                            return self.createSuccessPublisher(newScreenData)
                        }.eraseToAnyPublisher()
                case .worldwide:
                    return repository.getWorldwideData()
                        .subscribe(on: DispatchQueue.global(qos: .background))
                        .receive(on: RunLoop.main)
                        .flatMap { (result) -> AnyPublisher<Result<HomeScreenDomainItem, ErrorType>, Never> in
                            switch result {
                            case .success(let worldwideResponse):
                                let newScreenData: HomeScreenDomainItem = createScreenData(from: worldwideResponse)
                                return self.createSuccessPublisher(newScreenData)
                            case .failure(let error):
                                return self.createFailurePublisher(error)
                            }
                        }.eraseToAnyPublisher()
                }
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (result) in self.handleResult(result) }
    }
    
    func handleResult(_ result: Result<HomeScreenDomainItem, ErrorType>) {
        switch result {
        case .success(let item):
            screenData = item
            UserDefaultsService.update(createUserDefaultsDomainItem(from: item))
            updateScreenSubject.send(true)
        case .failure(let error):
            errorSubject.send(error)
        }
        loaderIsVisible = false
        //                self.loaderPublisher.send(false)
        viewControllerDelegate?.loaderOverlay.dismissLoader()
    }
    
    
    func createScreenData(from totalStats: [CountryResponseItem], and dayOneStats: [CountryResponseItem]) -> HomeScreenDomainItem {
        var screenData = HomeScreenDomainItem()
        if totalStats.count > 2,
           dayOneStats.count > 2 {
            let dayOneStatsLast = dayOneStats[dayOneStats.count - 2]    // skip today data (same data on api for today and yesterday)
            let totalLast = totalStats[totalStats.count - 2]            // skip today data (same data on api for today and yesterday)
            let dayOneStatsSecondToLast = dayOneStats[dayOneStats.count - 3]
            screenData.title = totalLast.country
            screenData.confirmedTotalCount = totalLast.confirmed
            screenData.confirmedDifferenceCount = dayOneStatsLast.confirmed - dayOneStatsSecondToLast.confirmed
            screenData.activeTotalCount = totalLast.active
            screenData.activeDifferenceCount = dayOneStatsLast.active - dayOneStatsSecondToLast.active
            screenData.recoveredTotalCount = totalLast.recovered
            screenData.recoveredDifferenceCount = dayOneStatsLast.recovered - dayOneStatsSecondToLast.recovered
            screenData.deathsTotalCount = totalLast.deaths
            screenData.deathsDifferenceCount = dayOneStatsLast.deaths - dayOneStatsSecondToLast.deaths
            screenData.details = createDetails(from: dayOneStats).reversed()
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
        screenData.details = createDetailsTop3WithConfirmedCases(from: item.countries)
        screenData.lastUpdateDate = Date()
        return screenData
    }
    
    func createDetailsTop3WithConfirmedCases(from items: [CountryStatus]) -> [HomeScreenDomainItemDetail] {
        let filteredItems = Array(items.sorted(by: { $0.totalConfirmed > $1.totalConfirmed }).prefix(3))
        return createDetails(from: filteredItems)
    }
    
    func createDetails(from responseItems: [CountryResponseItem]) -> [HomeScreenDomainItemDetail] {
        var newDetails = [HomeScreenDomainItemDetail]()
        #warning("using less items from api! Optimisation needed.")
        for (index, responseItem) in responseItems.suffix(1000).enumerated() {
            if index == 0 {
                var item = HomeScreenDomainItemDetail()
                item.title = DateUtils.getDomainDetailItemDate(from: responseItem.date) ?? ""
                item.confirmed = responseItem.confirmed
                item.recovered = responseItem.recovered
                item.deaths = responseItem.deaths
                item.active = responseItem.active
                newDetails.append(item)
            } else if index != responseItems.count - 1 {  // skip today data (same data on api for today and yesterday)
                let previousResponseItem = responseItems[index - 1]
                var item = HomeScreenDomainItemDetail()
                item.title = DateUtils.getDomainDetailItemDate(from: responseItem.date) ?? ""
                item.confirmed = responseItem.confirmed - previousResponseItem.confirmed
                item.recovered = responseItem.recovered - previousResponseItem.recovered
                item.deaths = responseItem.deaths - previousResponseItem.deaths
                item.active = responseItem.active - previousResponseItem.active
                newDetails.append(item)
            }
        }
        return newDetails
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
        return newDetails
    }
    func createSlug(_ string: String) -> String {
        return string.lowercased().replacingOccurrences(of: " ", with: "-")
    }
    
    func createUserDefaultsDomainItem(from value: HomeScreenDomainItem) -> UserDefaultsDomainItem {
        switch value.title {
        case "Worldwide":
            return UserDefaultsDomainItem(usecase: createSlug(value.title), details: value.details.map({ $0.title}))
        default:
            return UserDefaultsDomainItem(usecase: createSlug(value.title), details: [value.title])
        }
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

extension HomeScreenViewModel {
    func didUpdateLocations(_ locations: [CLLocation]) {
        if let location = locations.last {
            CLGeocoder().reverseGeocodeLocation(location) { [unowned self] placemarks, error in
                guard let country: String = placemarks?.first?.country,
                      error == nil else { return }
                let slug = country.lowercased().replacingOccurrences(of: " ", with: "-")
                self.usecase = .country(slug)
                let item = UserDefaultsDomainItem(usecase: slug, details: .init())
                UserDefaultsService.update(item)
                getData()
            }
        }
    }
    
    func didChangeAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            viewControllerDelegate?.locationManager.startUpdatingLocation()
        default:
            getData()
        }
    }
}
