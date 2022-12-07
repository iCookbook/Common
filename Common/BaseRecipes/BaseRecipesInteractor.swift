//
//  BaseRecipesInteractor.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  
//

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
    ///
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
    
    public func provideImageData(for recipes: [Recipe]) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        for i in 0..<recipes.count {
            group.enter()
            print("1")
            self.networkManager.obtainData(by: recipes[i].image ?? "") { [unowned self] (result) in
                switch result {
                case .success(let newData):
                    recipes[i].imageData = newData
                case .failure(_):
                    recipes[i].imageData = nil
                }
                print("2")
                group.leave()
            }
            print("3")
        }
        presenter?.didProvidedImageData(for: recipes)
    }
    
    /// Provides **raw** data by provided url..
    ///
    /// - Parameter urlString: url link to the source of data.
    public func provideRawData(urlString: String?) -> Data? {
        
        var data: Data?
        
        guard let urlString = urlString else {
            presenter?.handleError(.invalidURL)
            return nil
        }
        print("1")
        networkManager.obtainData(by: urlString) { result in
            switch result {
            case .success(let newData):
                data = newData
            case .failure(_):
                data = nil
            }
            print("2")
        }
        print("3")
        return data
    }
}
