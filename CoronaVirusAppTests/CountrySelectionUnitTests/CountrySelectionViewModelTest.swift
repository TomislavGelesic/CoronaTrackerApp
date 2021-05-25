//
//  CountrySelectionViewModelTest.swift
//  CoronaVirusAppTests
//
//  Created by Ivan Simunovic on 20.04.2021..
//

import Cuckoo
import Quick
import Nimble
import Combine
import UIKit

@testable import CoronaVirusApp

class CountrySelectionViewModelTest: QuickSpec {

    func getResource<T: Codable>() -> T? {
        let bundle = Bundle.init(for: CountrySelectionViewModelTest.self)
        guard let resourcePath = bundle.url(forResource: "Covid19CountryList", withExtension: "json"),
        let data = try? Data(contentsOf: resourcePath),
        let parsedData: T = SerializationManager.parseData(jsonData: data) else {
            return nil
        }
        return parsedData
    }
    
    override func spec() {
        describe("Test for view model") {
            let mockRepository = MockCovid19RepositoryImpl()
            var viewModel: CountrySelectionViewModel!
            var disposeBag = Set<AnyCancellable>()
            
            context("Screen data initialized successfuly") {
                beforeEach {
                    successStub()
                    setupViewModel()
                }
                
                it("Screeen initalized") {
                    viewModel.loadData.send(false)
                    expect(viewModel.screenData.count).toEventually(equal(249))
                    expect(viewModel.screenData[0].content).toEventually(equal("Worldwide"), timeout: .seconds(2))
                    expect(viewModel.screenData[1].content).toEventually(equal("ALA Aland Islands"), timeout: .seconds(2))
                    expect(viewModel.screenData[2].content).toEventually(equal("Afghanistan"), timeout: .seconds(2))
                }
            }
            
            context("Initialization got error") {
                beforeEach {
                    failStub()
                    setupViewModel()
                }
                
                it("Screeen initalized") {
                    viewModel.loadData.send(true)
                    expect(viewModel.screenData.count).toEventually(equal(0))
                }
            }
            
            func setupViewModel() {
                viewModel = CountrySelectionViewModel(repository: mockRepository)
                viewModel.initializeScreenData(with: viewModel.loadData).store(in: &disposeBag)
            }
            
            func successStub() {
                stub(mockRepository) { (mock) in
                    guard let response: [CountryListResponseItem] = getResource() else { return }
                    let publisher = Just<Result<[CountryListResponseItem], ErrorType>>(.success(response)).eraseToAnyPublisher()
                    when(mock.getCountriesList()).thenReturn(publisher)
                }
            }
            
            func failStub() {
                stub(mockRepository) { mock in
                    let publisher =  Just<Result<[CountryListResponseItem], ErrorType>>(.failure(.general)).eraseToAnyPublisher()
                    when(mock.getCountriesList()).thenReturn(publisher)
                   
                }
            }
        }
    }
}

