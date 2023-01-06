//
//  SpyBaseRecipesView.swift
//  Search-Unit-Tests
//
//  Created by Егор Бадмаев on 06.01.2023.
//

import XCTest
@testable import Common
@testable import Models

class SpyBaseRecipesView: BaseRecipesViewInput {
    
    var dataToDisplay: [Recipe]!
    var withOverridingCurrentDataFlag: Bool!
    
    var errorTitleProvided: String!
    var errorMessageProvided: String!
    var errorImageProvided: UIImage?
    
    var expectation: XCTestExpectation!
    
    func fillData(with data: [Recipe], withOverridingCurrentData: Bool) {
        dataToDisplay = data
        withOverridingCurrentDataFlag = withOverridingCurrentData
    }
    
    func displayError(title: String, message: String, image: UIImage?) {
        errorTitleProvided = title
        errorMessageProvided = message
        errorImageProvided = image
        
        if let expectation = expectation {
            expectation.fulfill()
        }
    }
}
