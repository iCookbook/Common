//
//  BaseRecipesInteractorTests.swift
//  Common-Unit-Tests
//
//  Created by Егор Бадмаев on 03.01.2023.
//

import XCTest
@testable import Common

class BaseRecipesInteractorTests: XCTestCase {
    
    /// SUT.
    var interactor: BaseRecipesInteractor!
    let mockNetworkManager = MockNetworkManager()
    
    override func setUpWithError() throws {
        interactor = BaseRecipesInteractor(networkManager: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        interactor = nil
    }
    
    func testExample() throws {
    }
}
