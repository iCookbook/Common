//
//  SpyBaseRecipesPresenter.swift
//  Common-Unit-Tests
//
//  Created by Егор Бадмаев on 06.01.2023.
//

import XCTest
@testable import Common
@testable import Models
@testable import Networking

class SpyBaseRecipesPresenter: BaseRecipesInteractorOutput {
    
    var providedResponse: Response!
    var withOverridingCurrentDataFlag: Bool!
    var providedError: NetworkManagerError!
    
    var expectation: XCTestExpectation!
    
    func didProvideResponse(_ response: Response, withOverridingCurrentData: Bool) {
        providedResponse = response
        withOverridingCurrentDataFlag = withOverridingCurrentData
        
        if let expectation = expectation {
            expectation.fulfill()
        }
    }
    
    func handleError(_ error: NetworkManagerError) {
        providedError = error
    }
}
