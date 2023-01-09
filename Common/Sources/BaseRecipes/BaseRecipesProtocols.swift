//
//  BaseRecipesProtocols.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  

import Models
import Networking

public protocol BaseRecipesDependenciesProtocol {
    var moduleOutput: BaseRecipesModuleOutput? { get set }
    var networkManager: NetworkManagerProtocol { get }
}

public protocol BaseRecipesModuleInput {
    var moduleOutput: BaseRecipesModuleOutput? { get }
}

public protocol BaseRecipesModuleOutput: AnyObject {
}

public protocol BaseRecipesViewInput: AnyObject {
    func fillData(with data: [Recipe], withOverridingCurrentData: Bool)
    func displayError(title: String, message: String, image: UIImage?)
}

public protocol BaseRecipesViewOutput: AnyObject {
    func requestRandomData()
    func requestData()
    func didSelectRecipe(_ recipe: Recipe)
    func resetAllActivity()
    func willRequestDataForPagination() -> Bool
}

public protocol BaseRecipesInteractorInput: AnyObject {
    func provideRandomData()
    func provideData(urlString: String?)
}

public protocol BaseRecipesInteractorOutput: AnyObject {
    func didProvideResponse(_ response: Response, withOverridingCurrentData: Bool)
    func handleError(_ error: NetworkManagerError)
}

public protocol BaseRecipesRouterInput: AnyObject {
    func openRecipeDetailsModule(for recipe: Recipe)
}

public protocol BaseRecipesRouterOutput: AnyObject {
}
