// MARK: - Mocks generated from file: CoronaVirusApp/Common/Networking/Repositories/Covid19RepositoryImpl.swift at 2021-05-25 14:59:24 +0000


import Cuckoo
@testable import CoronaVirusApp

import Combine
import Foundation


 class MockCovid19RepositoryImpl: Covid19RepositoryImpl, Cuckoo.ClassMock {
    
     typealias MocksType = Covid19RepositoryImpl
    
     typealias Stubbing = __StubbingProxy_Covid19RepositoryImpl
     typealias Verification = __VerificationProxy_Covid19RepositoryImpl

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: Covid19RepositoryImpl?

     func enableDefaultImplementation(_ stub: Covid19RepositoryImpl) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func getCountriesList() -> AnyPublisher<Result<[CountryListResponseItem], ErrorType>, Never> {
        
    return cuckoo_manager.call("getCountriesList() -> AnyPublisher<Result<[CountryListResponseItem], ErrorType>, Never>",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getCountriesList()
                ,
            defaultCall: __defaultImplStub!.getCountriesList())
        
    }
    
    
    
     override func getCountryStatsTotal(for countryName: String) -> AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never> {
        
    return cuckoo_manager.call("getCountryStatsTotal(for: String) -> AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>",
            parameters: (countryName),
            escapingParameters: (countryName),
            superclassCall:
                
                super.getCountryStatsTotal(for: countryName)
                ,
            defaultCall: __defaultImplStub!.getCountryStatsTotal(for: countryName))
        
    }
    
    
    
     override func getCountryStats(for countryName: String) -> AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never> {
        
    return cuckoo_manager.call("getCountryStats(for: String) -> AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>",
            parameters: (countryName),
            escapingParameters: (countryName),
            superclassCall:
                
                super.getCountryStats(for: countryName)
                ,
            defaultCall: __defaultImplStub!.getCountryStats(for: countryName))
        
    }
    
    
    
     override func getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never> {
        
    return cuckoo_manager.call("getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getWorldwideData()
                ,
            defaultCall: __defaultImplStub!.getWorldwideData())
        
    }
    

	 struct __StubbingProxy_Covid19RepositoryImpl: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func getCountriesList() -> Cuckoo.ClassStubFunction<(), AnyPublisher<Result<[CountryListResponseItem], ErrorType>, Never>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCovid19RepositoryImpl.self, method: "getCountriesList() -> AnyPublisher<Result<[CountryListResponseItem], ErrorType>, Never>", parameterMatchers: matchers))
	    }
	    
	    func getCountryStatsTotal<M1: Cuckoo.Matchable>(for countryName: M1) -> Cuckoo.ClassStubFunction<(String), AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: countryName) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCovid19RepositoryImpl.self, method: "getCountryStatsTotal(for: String) -> AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>", parameterMatchers: matchers))
	    }
	    
	    func getCountryStats<M1: Cuckoo.Matchable>(for countryName: M1) -> Cuckoo.ClassStubFunction<(String), AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: countryName) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockCovid19RepositoryImpl.self, method: "getCountryStats(for: String) -> AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>", parameterMatchers: matchers))
	    }
	    
	    func getWorldwideData() -> Cuckoo.ClassStubFunction<(), AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockCovid19RepositoryImpl.self, method: "getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_Covid19RepositoryImpl: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func getCountriesList() -> Cuckoo.__DoNotUse<(), AnyPublisher<Result<[CountryListResponseItem], ErrorType>, Never>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getCountriesList() -> AnyPublisher<Result<[CountryListResponseItem], ErrorType>, Never>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getCountryStatsTotal<M1: Cuckoo.Matchable>(for countryName: M1) -> Cuckoo.__DoNotUse<(String), AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: countryName) { $0 }]
	        return cuckoo_manager.verify("getCountryStatsTotal(for: String) -> AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getCountryStats<M1: Cuckoo.Matchable>(for countryName: M1) -> Cuckoo.__DoNotUse<(String), AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: countryName) { $0 }]
	        return cuckoo_manager.verify("getCountryStats(for: String) -> AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getWorldwideData() -> Cuckoo.__DoNotUse<(), AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class Covid19RepositoryImplStub: Covid19RepositoryImpl {
    

    

    
     override func getCountriesList() -> AnyPublisher<Result<[CountryListResponseItem], ErrorType>, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<[CountryListResponseItem], ErrorType>, Never>).self)
    }
    
     override func getCountryStatsTotal(for countryName: String) -> AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>).self)
    }
    
     override func getCountryStats(for countryName: String) -> AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<[CountryResponseItem], ErrorType>, Never>).self)
    }
    
     override func getWorldwideData() -> AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>  {
        return DefaultValueRegistry.defaultValue(for: (AnyPublisher<Result<WorldwideResponseItem, ErrorType>, Never>).self)
    }
    
}


// MARK: - Mocks generated from file: CoronaVirusApp/Modules/HomeScreen/Coordinators/HomeScreenCoordinatorImpl.swift at 2021-05-25 14:59:24 +0000


import Cuckoo
@testable import CoronaVirusApp

import UIKit


 class MockHomeScreenCoordinatorImpl: HomeScreenCoordinatorImpl, Cuckoo.ClassMock {
    
     typealias MocksType = HomeScreenCoordinatorImpl
    
     typealias Stubbing = __StubbingProxy_HomeScreenCoordinatorImpl
     typealias Verification = __VerificationProxy_HomeScreenCoordinatorImpl

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: HomeScreenCoordinatorImpl?

     func enableDefaultImplementation(_ stub: HomeScreenCoordinatorImpl) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     override var childCoordinators: [Coordinator] {
        get {
            return cuckoo_manager.getter("childCoordinators",
                superclassCall:
                    
                    super.childCoordinators
                    ,
                defaultCall: __defaultImplStub!.childCoordinators)
        }
        
        set {
            cuckoo_manager.setter("childCoordinators",
                value: newValue,
                superclassCall:
                    
                    super.childCoordinators = newValue
                    ,
                defaultCall: __defaultImplStub!.childCoordinators = newValue)
        }
        
    }
    
    
    
     override var presenter: UINavigationController {
        get {
            return cuckoo_manager.getter("presenter",
                superclassCall:
                    
                    super.presenter
                    ,
                defaultCall: __defaultImplStub!.presenter)
        }
        
        set {
            cuckoo_manager.setter("presenter",
                value: newValue,
                superclassCall:
                    
                    super.presenter = newValue
                    ,
                defaultCall: __defaultImplStub!.presenter = newValue)
        }
        
    }
    
    
    
     override var parentCoordinator: (ParentCoordinatorDelegate & CountrySelectionHandler)? {
        get {
            return cuckoo_manager.getter("parentCoordinator",
                superclassCall:
                    
                    super.parentCoordinator
                    ,
                defaultCall: __defaultImplStub!.parentCoordinator)
        }
        
        set {
            cuckoo_manager.setter("parentCoordinator",
                value: newValue,
                superclassCall:
                    
                    super.parentCoordinator = newValue
                    ,
                defaultCall: __defaultImplStub!.parentCoordinator = newValue)
        }
        
    }
    
    
    
     override var controller: HomeScreenViewController {
        get {
            return cuckoo_manager.getter("controller",
                superclassCall:
                    
                    super.controller
                    ,
                defaultCall: __defaultImplStub!.controller)
        }
        
        set {
            cuckoo_manager.setter("controller",
                value: newValue,
                superclassCall:
                    
                    super.controller = newValue
                    ,
                defaultCall: __defaultImplStub!.controller = newValue)
        }
        
    }
    

    

    
    
    
     override func start()  {
        
    return cuckoo_manager.call("start()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.start()
                ,
            defaultCall: __defaultImplStub!.start())
        
    }
    
    
    
     override func openCountrySelection()  {
        
    return cuckoo_manager.call("openCountrySelection()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.openCountrySelection()
                ,
            defaultCall: __defaultImplStub!.openCountrySelection())
        
    }
    
    
    
     override func viewControllerDidFinish()  {
        
    return cuckoo_manager.call("viewControllerDidFinish()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.viewControllerDidFinish()
                ,
            defaultCall: __defaultImplStub!.viewControllerDidFinish())
        
    }
    

	 struct __StubbingProxy_HomeScreenCoordinatorImpl: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var childCoordinators: Cuckoo.ClassToBeStubbedProperty<MockHomeScreenCoordinatorImpl, [Coordinator]> {
	        return .init(manager: cuckoo_manager, name: "childCoordinators")
	    }
	    
	    
	    var presenter: Cuckoo.ClassToBeStubbedProperty<MockHomeScreenCoordinatorImpl, UINavigationController> {
	        return .init(manager: cuckoo_manager, name: "presenter")
	    }
	    
	    
	    var parentCoordinator: Cuckoo.ClassToBeStubbedOptionalProperty<MockHomeScreenCoordinatorImpl, (ParentCoordinatorDelegate & CountrySelectionHandler)> {
	        return .init(manager: cuckoo_manager, name: "parentCoordinator")
	    }
	    
	    
	    var controller: Cuckoo.ClassToBeStubbedProperty<MockHomeScreenCoordinatorImpl, HomeScreenViewController> {
	        return .init(manager: cuckoo_manager, name: "controller")
	    }
	    
	    
	    func start() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockHomeScreenCoordinatorImpl.self, method: "start()", parameterMatchers: matchers))
	    }
	    
	    func openCountrySelection() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockHomeScreenCoordinatorImpl.self, method: "openCountrySelection()", parameterMatchers: matchers))
	    }
	    
	    func viewControllerDidFinish() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockHomeScreenCoordinatorImpl.self, method: "viewControllerDidFinish()", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_HomeScreenCoordinatorImpl: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var childCoordinators: Cuckoo.VerifyProperty<[Coordinator]> {
	        return .init(manager: cuckoo_manager, name: "childCoordinators", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var presenter: Cuckoo.VerifyProperty<UINavigationController> {
	        return .init(manager: cuckoo_manager, name: "presenter", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var parentCoordinator: Cuckoo.VerifyOptionalProperty<(ParentCoordinatorDelegate & CountrySelectionHandler)> {
	        return .init(manager: cuckoo_manager, name: "parentCoordinator", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var controller: Cuckoo.VerifyProperty<HomeScreenViewController> {
	        return .init(manager: cuckoo_manager, name: "controller", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func start() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("start()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func openCountrySelection() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("openCountrySelection()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func viewControllerDidFinish() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("viewControllerDidFinish()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class HomeScreenCoordinatorImplStub: HomeScreenCoordinatorImpl {
    
    
     override var childCoordinators: [Coordinator] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([Coordinator]).self)
        }
        
        set { }
        
    }
    
    
     override var presenter: UINavigationController {
        get {
            return DefaultValueRegistry.defaultValue(for: (UINavigationController).self)
        }
        
        set { }
        
    }
    
    
     override var parentCoordinator: (ParentCoordinatorDelegate & CountrySelectionHandler)? {
        get {
            return DefaultValueRegistry.defaultValue(for: ((ParentCoordinatorDelegate & CountrySelectionHandler)?).self)
        }
        
        set { }
        
    }
    
    
     override var controller: HomeScreenViewController {
        get {
            return DefaultValueRegistry.defaultValue(for: (HomeScreenViewController).self)
        }
        
        set { }
        
    }
    

    

    
     override func start()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func openCountrySelection()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     override func viewControllerDidFinish()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: CoronaVirusApp/Modules/LatestNews/ViewModel/LatestNewsViewModel.swift at 2021-05-25 14:59:24 +0000

//
//  LatestNewsViewModel.swift
//  CoronaVirusApp
//
//  Created by Ivan Simunovic on 30.04.2021..
//

import Cuckoo
@testable import CoronaVirusApp

import Combine
import Foundation


 class MockLatestNewsViewModel: LatestNewsViewModel, Cuckoo.ClassMock {
    
     typealias MocksType = LatestNewsViewModel
    
     typealias Stubbing = __StubbingProxy_LatestNewsViewModel
     typealias Verification = __VerificationProxy_LatestNewsViewModel

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: LatestNewsViewModel?

     func enableDefaultImplementation(_ stub: LatestNewsViewModel) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     override var loadingInProgress: Bool {
        get {
            return cuckoo_manager.getter("loadingInProgress",
                superclassCall:
                    
                    super.loadingInProgress
                    ,
                defaultCall: __defaultImplStub!.loadingInProgress)
        }
        
        set {
            cuckoo_manager.setter("loadingInProgress",
                value: newValue,
                superclassCall:
                    
                    super.loadingInProgress = newValue
                    ,
                defaultCall: __defaultImplStub!.loadingInProgress = newValue)
        }
        
    }
    
    
    
     override var pagesAvailable: Bool {
        get {
            return cuckoo_manager.getter("pagesAvailable",
                superclassCall:
                    
                    super.pagesAvailable
                    ,
                defaultCall: __defaultImplStub!.pagesAvailable)
        }
        
        set {
            cuckoo_manager.setter("pagesAvailable",
                value: newValue,
                superclassCall:
                    
                    super.pagesAvailable = newValue
                    ,
                defaultCall: __defaultImplStub!.pagesAvailable = newValue)
        }
        
    }
    
    
    
     override var screenData: [LatestNewsDomainItem] {
        get {
            return cuckoo_manager.getter("screenData",
                superclassCall:
                    
                    super.screenData
                    ,
                defaultCall: __defaultImplStub!.screenData)
        }
        
        set {
            cuckoo_manager.setter("screenData",
                value: newValue,
                superclassCall:
                    
                    super.screenData = newValue
                    ,
                defaultCall: __defaultImplStub!.screenData = newValue)
        }
        
    }
    
    
    
     override var coordinatorDelegate: LatestNewsCoordinatorDelegate? {
        get {
            return cuckoo_manager.getter("coordinatorDelegate",
                superclassCall:
                    
                    super.coordinatorDelegate
                    ,
                defaultCall: __defaultImplStub!.coordinatorDelegate)
        }
        
        set {
            cuckoo_manager.setter("coordinatorDelegate",
                value: newValue,
                superclassCall:
                    
                    super.coordinatorDelegate = newValue
                    ,
                defaultCall: __defaultImplStub!.coordinatorDelegate = newValue)
        }
        
    }
    
    
    
     override var loaderPublisher: CurrentValueSubject<Bool, Never> {
        get {
            return cuckoo_manager.getter("loaderPublisher",
                superclassCall:
                    
                    super.loaderPublisher
                    ,
                defaultCall: __defaultImplStub!.loaderPublisher)
        }
        
        set {
            cuckoo_manager.setter("loaderPublisher",
                value: newValue,
                superclassCall:
                    
                    super.loaderPublisher = newValue
                    ,
                defaultCall: __defaultImplStub!.loaderPublisher = newValue)
        }
        
    }
    
    
    
     override var errorSubject: PassthroughSubject<ErrorType?, Never> {
        get {
            return cuckoo_manager.getter("errorSubject",
                superclassCall:
                    
                    super.errorSubject
                    ,
                defaultCall: __defaultImplStub!.errorSubject)
        }
        
        set {
            cuckoo_manager.setter("errorSubject",
                value: newValue,
                superclassCall:
                    
                    super.errorSubject = newValue
                    ,
                defaultCall: __defaultImplStub!.errorSubject = newValue)
        }
        
    }
    

    

    

	 struct __StubbingProxy_LatestNewsViewModel: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var loadingInProgress: Cuckoo.ClassToBeStubbedProperty<MockLatestNewsViewModel, Bool> {
	        return .init(manager: cuckoo_manager, name: "loadingInProgress")
	    }
	    
	    
	    var pagesAvailable: Cuckoo.ClassToBeStubbedProperty<MockLatestNewsViewModel, Bool> {
	        return .init(manager: cuckoo_manager, name: "pagesAvailable")
	    }
	    
	    
	    var screenData: Cuckoo.ClassToBeStubbedProperty<MockLatestNewsViewModel, [LatestNewsDomainItem]> {
	        return .init(manager: cuckoo_manager, name: "screenData")
	    }
	    
	    
	    var coordinatorDelegate: Cuckoo.ClassToBeStubbedOptionalProperty<MockLatestNewsViewModel, LatestNewsCoordinatorDelegate> {
	        return .init(manager: cuckoo_manager, name: "coordinatorDelegate")
	    }
	    
	    
	    var loaderPublisher: Cuckoo.ClassToBeStubbedProperty<MockLatestNewsViewModel, CurrentValueSubject<Bool, Never>> {
	        return .init(manager: cuckoo_manager, name: "loaderPublisher")
	    }
	    
	    
	    var errorSubject: Cuckoo.ClassToBeStubbedProperty<MockLatestNewsViewModel, PassthroughSubject<ErrorType?, Never>> {
	        return .init(manager: cuckoo_manager, name: "errorSubject")
	    }
	    
	    
	}

	 struct __VerificationProxy_LatestNewsViewModel: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var loadingInProgress: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "loadingInProgress", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var pagesAvailable: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "pagesAvailable", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var screenData: Cuckoo.VerifyProperty<[LatestNewsDomainItem]> {
	        return .init(manager: cuckoo_manager, name: "screenData", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var coordinatorDelegate: Cuckoo.VerifyOptionalProperty<LatestNewsCoordinatorDelegate> {
	        return .init(manager: cuckoo_manager, name: "coordinatorDelegate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var loaderPublisher: Cuckoo.VerifyProperty<CurrentValueSubject<Bool, Never>> {
	        return .init(manager: cuckoo_manager, name: "loaderPublisher", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var errorSubject: Cuckoo.VerifyProperty<PassthroughSubject<ErrorType?, Never>> {
	        return .init(manager: cuckoo_manager, name: "errorSubject", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}
}

 class LatestNewsViewModelStub: LatestNewsViewModel {
    
    
     override var loadingInProgress: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
     override var pagesAvailable: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
    
     override var screenData: [LatestNewsDomainItem] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([LatestNewsDomainItem]).self)
        }
        
        set { }
        
    }
    
    
     override var coordinatorDelegate: LatestNewsCoordinatorDelegate? {
        get {
            return DefaultValueRegistry.defaultValue(for: (LatestNewsCoordinatorDelegate?).self)
        }
        
        set { }
        
    }
    
    
     override var loaderPublisher: CurrentValueSubject<Bool, Never> {
        get {
            return DefaultValueRegistry.defaultValue(for: (CurrentValueSubject<Bool, Never>).self)
        }
        
        set { }
        
    }
    
    
     override var errorSubject: PassthroughSubject<ErrorType?, Never> {
        get {
            return DefaultValueRegistry.defaultValue(for: (PassthroughSubject<ErrorType?, Never>).self)
        }
        
        set { }
        
    }
    

    

    
}


// MARK: - Mocks generated from file: CoronaVirusApp/Modules/StatisticsScreen/Coordinator/StatisticsScreenCoordinator.swift at 2021-05-25 14:59:24 +0000


import Cuckoo
@testable import CoronaVirusApp

import MapKit
import UIKit


 class MockStatisticsScreenCoordinator: StatisticsScreenCoordinator, Cuckoo.ClassMock {
    
     typealias MocksType = StatisticsScreenCoordinator
    
     typealias Stubbing = __StubbingProxy_StatisticsScreenCoordinator
     typealias Verification = __VerificationProxy_StatisticsScreenCoordinator

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: StatisticsScreenCoordinator?

     func enableDefaultImplementation(_ stub: StatisticsScreenCoordinator) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     override var parent: (ParentCoordinatorDelegate & CountrySelectionHandler)? {
        get {
            return cuckoo_manager.getter("parent",
                superclassCall:
                    
                    super.parent
                    ,
                defaultCall: __defaultImplStub!.parent)
        }
        
        set {
            cuckoo_manager.setter("parent",
                value: newValue,
                superclassCall:
                    
                    super.parent = newValue
                    ,
                defaultCall: __defaultImplStub!.parent = newValue)
        }
        
    }
    
    
    
     override var childCoordinators: [Coordinator] {
        get {
            return cuckoo_manager.getter("childCoordinators",
                superclassCall:
                    
                    super.childCoordinators
                    ,
                defaultCall: __defaultImplStub!.childCoordinators)
        }
        
        set {
            cuckoo_manager.setter("childCoordinators",
                value: newValue,
                superclassCall:
                    
                    super.childCoordinators = newValue
                    ,
                defaultCall: __defaultImplStub!.childCoordinators = newValue)
        }
        
    }
    
    
    
     override var presenter: UINavigationController {
        get {
            return cuckoo_manager.getter("presenter",
                superclassCall:
                    
                    super.presenter
                    ,
                defaultCall: __defaultImplStub!.presenter)
        }
        
        set {
            cuckoo_manager.setter("presenter",
                value: newValue,
                superclassCall:
                    
                    super.presenter = newValue
                    ,
                defaultCall: __defaultImplStub!.presenter = newValue)
        }
        
    }
    
    
    
     override var controller: StatistiscScreenViewController {
        get {
            return cuckoo_manager.getter("controller",
                superclassCall:
                    
                    super.controller
                    ,
                defaultCall: __defaultImplStub!.controller)
        }
        
        set {
            cuckoo_manager.setter("controller",
                value: newValue,
                superclassCall:
                    
                    super.controller = newValue
                    ,
                defaultCall: __defaultImplStub!.controller = newValue)
        }
        
    }
    

    

    
    
    
     override func start()  {
        
    return cuckoo_manager.call("start()",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.start()
                ,
            defaultCall: __defaultImplStub!.start())
        
    }
    

	 struct __StubbingProxy_StatisticsScreenCoordinator: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var parent: Cuckoo.ClassToBeStubbedOptionalProperty<MockStatisticsScreenCoordinator, (ParentCoordinatorDelegate & CountrySelectionHandler)> {
	        return .init(manager: cuckoo_manager, name: "parent")
	    }
	    
	    
	    var childCoordinators: Cuckoo.ClassToBeStubbedProperty<MockStatisticsScreenCoordinator, [Coordinator]> {
	        return .init(manager: cuckoo_manager, name: "childCoordinators")
	    }
	    
	    
	    var presenter: Cuckoo.ClassToBeStubbedProperty<MockStatisticsScreenCoordinator, UINavigationController> {
	        return .init(manager: cuckoo_manager, name: "presenter")
	    }
	    
	    
	    var controller: Cuckoo.ClassToBeStubbedProperty<MockStatisticsScreenCoordinator, StatistiscScreenViewController> {
	        return .init(manager: cuckoo_manager, name: "controller")
	    }
	    
	    
	    func start() -> Cuckoo.ClassStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockStatisticsScreenCoordinator.self, method: "start()", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_StatisticsScreenCoordinator: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var parent: Cuckoo.VerifyOptionalProperty<(ParentCoordinatorDelegate & CountrySelectionHandler)> {
	        return .init(manager: cuckoo_manager, name: "parent", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var childCoordinators: Cuckoo.VerifyProperty<[Coordinator]> {
	        return .init(manager: cuckoo_manager, name: "childCoordinators", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var presenter: Cuckoo.VerifyProperty<UINavigationController> {
	        return .init(manager: cuckoo_manager, name: "presenter", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    
	    var controller: Cuckoo.VerifyProperty<StatistiscScreenViewController> {
	        return .init(manager: cuckoo_manager, name: "controller", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func start() -> Cuckoo.__DoNotUse<(), Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("start()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class StatisticsScreenCoordinatorStub: StatisticsScreenCoordinator {
    
    
     override var parent: (ParentCoordinatorDelegate & CountrySelectionHandler)? {
        get {
            return DefaultValueRegistry.defaultValue(for: ((ParentCoordinatorDelegate & CountrySelectionHandler)?).self)
        }
        
        set { }
        
    }
    
    
     override var childCoordinators: [Coordinator] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([Coordinator]).self)
        }
        
        set { }
        
    }
    
    
     override var presenter: UINavigationController {
        get {
            return DefaultValueRegistry.defaultValue(for: (UINavigationController).self)
        }
        
        set { }
        
    }
    
    
     override var controller: StatistiscScreenViewController {
        get {
            return DefaultValueRegistry.defaultValue(for: (StatistiscScreenViewController).self)
        }
        
        set { }
        
    }
    

    

    
     override func start()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}

