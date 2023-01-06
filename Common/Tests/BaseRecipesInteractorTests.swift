//
//  BaseRecipesInteractorTests.swift
//  Common-Unit-Tests
//
//  Created by Егор Бадмаев on 03.01.2023.
//

import XCTest
@testable import Common
@testable import Networking

class BaseRecipesInteractorTests: XCTestCase {
    
    var presenter: SpyBaseRecipesPresenter!
    /// SUT.
    var interactor: BaseRecipesInteractor!
    var stubNetworkManager: StubNetworkManager!
    
    override func setUpWithError() throws {
        stubNetworkManager = StubNetworkManager()
        interactor = BaseRecipesInteractor(networkManager: stubNetworkManager)
        presenter = SpyBaseRecipesPresenter()
        interactor.presenter = presenter
    }
    
    override func tearDownWithError() throws {
        interactor = nil
        presenter = nil
        stubNetworkManager = nil
    }
    
    func test_providingRandomData_success() throws {
        let expectation = expectation(description: "waitingForAnswerForInteractor")
        presenter.expectation = expectation
        stubNetworkManager.isSuccess = true
        
        interactor.provideRandomData()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(presenter.providedResponse)
        XCTAssertNotNil(presenter.withOverridingCurrentDataFlag)
        
        XCTAssertNil(presenter.providedError)
    }
    
    func test_providingRandomData_failure() throws {
        stubNetworkManager.isSuccess = false
        
        interactor.provideRandomData()
        
        XCTAssertNil(presenter.providedResponse)
        XCTAssertNil(presenter.withOverridingCurrentDataFlag)
        
        XCTAssertNotNil(presenter.providedError)
    }
    
    func test_providingDataByUrlString_success() throws {
        let expectation = expectation(description: "waitingForAnswerForInteractor")
        presenter.expectation = expectation
        stubNetworkManager.isSuccess = true
        
        interactor.provideData(urlString: "example.com")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(presenter.providedResponse)
        XCTAssertNotNil(presenter.withOverridingCurrentDataFlag)
        
        XCTAssertNil(presenter.providedError)
    }
    
    func test_providingDataByNilUrlString_failure() throws {
        stubNetworkManager.isSuccess = false
        
        interactor.provideData(urlString: nil)
        
        XCTAssertNil(presenter.providedResponse)
        XCTAssertNil(presenter.withOverridingCurrentDataFlag)
        
        XCTAssertNotNil(presenter.providedError)
        XCTAssertEqual(presenter.providedError, NetworkManagerError.invalidURL)
    }
    
    func test_providingDataByUrlString_failure() throws {
        stubNetworkManager.isSuccess = false
        
        interactor.provideData(urlString: "example.com")
        
        XCTAssertNil(presenter.providedResponse)
        XCTAssertNil(presenter.withOverridingCurrentDataFlag)
        
        XCTAssertNotNil(presenter.providedError)
    }
}
