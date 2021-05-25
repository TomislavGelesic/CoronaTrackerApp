//
//  HomeScreenInitTests.swift
//  CoronaVirusAppTests
//
//  Created by Tomislav Gelesic on 03.05.2021..
//

@testable import CoronaVirusApp
import Cuckoo
import Quick
import Nimble
import Combine

class HomeScreenInitialization: QuickSpec {
    
    func getLocalResource<T: Codable>(_ fileName: String) -> T? {
        let bundle = Bundle.init(for: HomeScreenInitialization.self)
        guard let resourcePath = bundle.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: resourcePath),
              let parsedData: T = SerializationManager.parseData(jsonData: data)
        else { return nil }
        return parsedData
    }
    
    override func spec() {
        
        var disposeBag = Set<AnyCancellable>()
        let mock = MockCovid19RepositoryImpl()
        var sut: HomeScreenViewModel!
        var failurePathCalled: Bool = false
        
        describe("Request") {
            context("country usecase initialize success screen.") {
                beforeEach {
                    stubCountryStats(withError: nil)
                    stubCountryStatsTotal(withError: nil)
                    initialize()
                }
                it("Success screen initialized.") {
                    let expectedDetailsCount:Int = 20
                    let expectedTopDetailConfirmed:Int = 0 // confirmed cases (7.5.21' - 6.5.21')
                    let expectedTotalConfirmed:Int = 280164
                    
                    sut.fetchScreenDataSubject.send(.country(""))
                    
                    expect(sut.screenData.details.count).toEventually(equal(expectedDetailsCount))
                    expect(sut.screenData.confirmedTotalCount).toEventually(equal(expectedTotalConfirmed))
                    expect(sut.screenData.details.first).toEventuallyNot(beNil())
                    expect(sut.screenData.details.first?.confirmed).toEventually(equal(expectedTopDetailConfirmed))
                }
            }
            
            context("country usecase initialize fail screen.") {
                beforeEach {
                    stubCountryStats(withError: .general)
                    stubCountryStatsTotal(withError: .noInternet)
                    initialize()
                }
                it("Fail screen initialized.") {
                    let expected = true
                    sut.fetchScreenDataSubject.send(.country(""))
                    expect(failurePathCalled).toEventually(equal(expected), timeout: .seconds(2))
                }
            }
            
            context("worldwide usecase initialize success screen.") {
                beforeEach {
                    stubWorldwideStats(withError: nil)
                    initialize()
                }
                it("Success screen initialized.") {
                    let expectedDetailsCount:Int = 3
                    let expectedDifferenceConfirmed:Int = 198996
                    let expectedTotalConfirmed:Int = 131539636
                    let expectedTopDetailConfirmed:Int = 126795
                    
                    sut.fetchScreenDataSubject.send(.worldwide)
                    
                    expect(sut.screenData.details.count).toEventually(equal(expectedDetailsCount))
                    expect(sut.screenData.confirmedDifferenceCount).toEventually(equal(expectedDifferenceConfirmed))
                    expect(sut.screenData.confirmedTotalCount).toEventually(equal(expectedTotalConfirmed))
                    expect(sut.screenData.details.first).toEventuallyNot(beNil())
                    expect(sut.screenData.details.first?.confirmed).toEventually(equal(expectedTopDetailConfirmed))
                }
            }
            
            context("worldwide usecase initialize fail screen.") {
                beforeEach {
                    stubWorldwideStats(withError: .general)
                    initialize()
                }
                it("Fail screen initialized.") {
                    let expected = true
                    sut.fetchScreenDataSubject.send(.worldwide)
                    expect(failurePathCalled).toEventually(equal(expected), timeout: .seconds(2))
                }
            }
        }
        func initialize() {
            sut = HomeScreenViewModel(repository: mock)
            
            sut.initializeFetchScreenDataSubject(sut.fetchScreenDataSubject)
                .store(in: &disposeBag)
            
            sut.errorSubject
                .receive(on: RunLoop.main)
                .sink { (_) in failurePathCalled = true }
                .store(in: &disposeBag)
        }
        func stubCountryStats(withError error: ErrorType?) {
            if let error = error {
                stub(mock) { stub in
                    let publisher = Just(Result<[CountryResponseItem], ErrorType>.failure(error)).eraseToAnyPublisher()
                    when(stub).getCountryStats(for: any()).thenReturn(publisher)
                }
            } else {
                stub(mock) { [unowned self] stub in
                    if let countryStatsResponse: [CountryResponseItem] = self.getLocalResource("Covid19CountryStats") {
                        let publisher = Just(Result<[CountryResponseItem], ErrorType>.success(countryStatsResponse)).eraseToAnyPublisher()
                        when(stub).getCountryStats(for: any()).thenReturn(publisher)
                    }
                }
            }
        }
        func stubCountryStatsTotal(withError error: ErrorType?) {
            if let error = error {
                stub(mock) { stub in
                    let publisher = Just(Result<[CountryResponseItem], ErrorType>.failure(error)).eraseToAnyPublisher()
                    when(stub).getCountryStatsTotal(for: any()).thenReturn(publisher)
                }
            } else {
                stub(mock) { [unowned self] stub in
                    if let countryStatsResponse: [CountryResponseItem] = self.getLocalResource("Covid19CountryTotalStats") {
                        let publisher = Just(Result<[CountryResponseItem], ErrorType>.success(countryStatsResponse)).eraseToAnyPublisher()
                        when(stub).getCountryStatsTotal(for: any()).thenReturn(publisher)
                    }
                }
            }
        }
        func stubWorldwideStats(withError error: ErrorType?) {
            if let error = error {
                stub(mock) { stub in
                    let publisher = Just(Result<WorldwideResponseItem, ErrorType>.failure(error)).eraseToAnyPublisher()
                    when(stub).getWorldwideData().thenReturn(publisher)
                }
            }
            else {
                stub(mock) { [unowned self] stub in
                    if let worldwideStatsResponse: WorldwideResponseItem = self.getLocalResource("Covid19WorldwideStats") {
                        let publisher = Just(Result<WorldwideResponseItem, ErrorType>.success(worldwideStatsResponse)).eraseToAnyPublisher()
                        when(stub).getWorldwideData().thenReturn(publisher)
                    }
                }
            }
        }
    }
}
