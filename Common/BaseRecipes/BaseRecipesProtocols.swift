//
//  BaseRecipesProtocols.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  
//

import Models
import Networking

public protocol BaseRecipesModuleInput {
    var moduleOutput: BaseRecipesModuleOutput? { get }
}

public protocol BaseRecipesModuleOutput: AnyObject {
}

public protocol BaseRecipesViewInput: AnyObject {
    func fillData(with data: [Recipe], nextPageUrl: String?, withOverridingCurrentData: Bool)
    func showAlert(title: String, message: String)
}

public protocol BaseRecipesViewOutput: AnyObject {
    func requestRandomData()
    func requestData(urlString: String?)
    func didSelectRecipe(_ recipe: Recipe)
}

public protocol BaseRecipesInteractorInput: AnyObject {
    func provideRandomData()
    func provideData(urlString: String?)
}

public protocol BaseRecipesInteractorOutput: AnyObject {
    func didProvidedResponse(_ response: Response, withOverridingCurrentData: Bool)
    func handleError(_ error: NetworkManagerError)
}

public protocol BaseRecipesRouterInput: AnyObject {
    func openRecipeDetailsModule(for recipe: Recipe)
}

public protocol BaseRecipesRouterOutput: AnyObject {
}
