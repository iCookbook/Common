//
//  BaseRecipesPresenterTests.swift
//  Common-Unit-Tests
//
//  Created by Егор Бадмаев on 06.01.2023.
//

import XCTest
@testable import Common
@testable import Models

class BaseRecipesPresenterTests: XCTestCase {
    
    let mockResponse = Response(from: nil, to: nil, count: nil, links: nil, hits: nil)
    let mockRouter = MockBaseRecipesRouter()
    let mockInteractor = MockBaseRecipesInteractor()
    var view: SpyBaseRecipesView!
    /// SUT.
    var presenter: BaseRecipesPresenter!
    
    override func setUpWithError() throws {
        presenter = BaseRecipesPresenter(router: mockRouter, interactor: mockInteractor)
        view = SpyBaseRecipesView()
        presenter.view = view
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        view = nil
    }
    
    /**
     Because of mock response, we will get empty data to display, but it should not be `nil`.
     */
    func testDidProvideResponseMethod_mockResponseFlagTrue() throws {
        let flag = true
        
        presenter.didProvideResponse(mockResponse, withOverridingCurrentData: flag)
        
        XCTAssertNotNil(view.dataToDisplay)
        XCTAssertTrue(view.dataToDisplay.isEmpty)
        XCTAssertEqual(view.withOverridingCurrentDataFlag, flag)
    }
    
    func testDidProvideResponseMethod_mockResponseFlagFalse() throws {
        let flag = false
        
        presenter.didProvideResponse(mockResponse, withOverridingCurrentData: flag)
        
        XCTAssertNotNil(view.dataToDisplay)
        XCTAssertTrue(view.dataToDisplay.isEmpty)
        XCTAssertEqual(view.withOverridingCurrentDataFlag, flag)
    }
    
    func testHandleErrorDataProviding() throws {
        // Given
        let expectation = expectation(description: "testHandleErrorDataProviding")
        view.expectation = expectation
        
        // When
        presenter.handleError(.decodingError)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(view.dataToDisplay)
        XCTAssertNil(view.withOverridingCurrentDataFlag)
        
        XCTAssertNotNil(view.errorTitleProvided)
        XCTAssertNotNil(view.errorMessageProvided)
        XCTAssertNotNil(view.errorImageProvided)
    }
}
