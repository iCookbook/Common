//
//  BaseRecipesInteractor.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  

import Foundation
import Networking
import Models

open class BaseRecipesInteractor {
    
    // MARK: - Public Properties
    
    public weak var presenter: BaseRecipesInteractorOutput?
    public let networkManager: NetworkManagerProtocol
    
    // MARK: - Init
    
    public init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    // MARK: - Public Methods
    
    /// Sets images' raw data for recipes in `response`.
    ///
    /// - Parameters:
    ///   - response: server response provided from the methods above.
    ///   - withOverridingCurrentData: defines whether to override current data with the new one or not.
    ///
    /// - Note: This method has `public` access level due to the usage outside of this module.
    public func setImageData(for response: Response, withOverridingCurrentData: Bool) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        for hit in response.hits ?? [] {
            guard let recipe = hit.recipe else { return }
            
            group.enter()
            
            queue.async {
                let endpoint = URLEndpoint(urlString: recipe.image ?? "")
                let request = NetworkRequest(endpoint: endpoint)
                
                self.networkManager.obtainData(request: request) { result in
                    switch result {
                    case .success(let data):
                        recipe.imageData = data
                    case .failure(_):
                        recipe.imageData = nil
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.presenter?.didProvideResponse(response, withOverridingCurrentData: withOverridingCurrentData)
        }
    }
}

extension BaseRecipesInteractor: BaseRecipesInteractorInput {
    
    /// Provides random data.
    public func provideRandomData() {
        let endpoint = Endpoint.random()
        let request = NetworkRequest(endpoint: endpoint)
        
        networkManager.perform(request: request) { [unowned self] (result: Result<Response, NetworkManagerError>) in
            switch result {
            case .success(let response):
                setImageData(for: response, withOverridingCurrentData: true)
            case .failure(let error):
                presenter?.handleError(error)
            }
        }
    }
    
    /// Provides data by provided url.
    ///
    /// - Parameter urlString: url link to the source of data.
    public func provideData(urlString: String?) {
        
        guard let urlString = urlString else {
            presenter?.handleError(.invalidURL)
            return
        }
        let endpoint = URLEndpoint(urlString: urlString)
        let request = NetworkRequest(endpoint: endpoint)
        
        networkManager.perform(request: request) { [unowned self] (result: Result<Response, NetworkManagerError>) in
            switch result {
            case .success(let response):
                setImageData(for: response, withOverridingCurrentData: false)
            case .failure(let error):
                presenter?.handleError(error)
            }
        }
    }
}
