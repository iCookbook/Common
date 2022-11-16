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
    
    public weak var presenter: BaseRecipesInteractorOutput?
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
                presenter?.didProvidedResponse(response, withOverridingCurrentData: true)
            case .failure(let error):
                presenter?.handleError(error)
            }
        }
    }
    
    /// Provides data by provided url.
    /// - Parameter urlString: url link to the source of data.
    public func provideData(urlString: String?) {
        
        guard let urlString = urlString else {
            presenter?.handleError(.invalidURL)
            return
        }
        let endpoint = URLEndpoint(urlString: urlString)
        
        let request = NetworkRequest(endpoint: endpoint)
        networkManager.getResponse(request: request) { [unowned self] (result) in
            switch result {
            case .success(let response):
                presenter?.didProvidedResponse(response, withOverridingCurrentData: false)
            case .failure(let error):
                presenter?.handleError(error)
            }
        }
    }
}
