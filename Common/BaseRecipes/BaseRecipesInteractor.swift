//
//  BaseRecipesInteractor.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  
//

import Networking

open class BaseRecipesInteractor {
    
    // MARK: - Public Properties
    
    public weak var output: BaseRecipesInteractorOutput?
    public let networkManager: NetworkManagerProtocol
    
    // MARK: - Init
    
    public init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension BaseRecipesInteractor: BaseRecipesInteractorInput {
    /// Provides random data.
    public func provideRandomData() {
        let request = NetworkRequest(endpoint: Endpoint.random())
        networkManager.getResponse(request: request) { [unowned self] (result) in
            switch result {
            case .success(let response):
                output?.didProvidedResponse(response, withOverridingCurrentData: true)
            case .failure(let error):
                output?.handleError(error)
            }
        }
    }
}
