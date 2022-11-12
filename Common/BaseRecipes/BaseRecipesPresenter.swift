//
//  BaseRecipesPresenter.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  
//

import Models
import Networking
import Resources

open class BaseRecipesPresenter {
    weak var view: BaseRecipesViewInput?
    weak public var moduleOutput: BaseRecipesModuleOutput?
    
    // MARK: - Private Properties
    
    public let router: BaseRecipesRouterInput
    public let interactor: BaseRecipesInteractorInput
    
    // MARK: - Init
    
    public init(router: BaseRecipesRouterInput, interactor: BaseRecipesInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension BaseRecipesPresenter: BaseRecipesModuleInput {
}

extension BaseRecipesPresenter: BaseRecipesViewOutput {
    
    public func requestRandomData() {
        interactor.provideRandomData()
    }
    
    public func didSelectRecipe(_ recipe: Recipe) {
        router.openRecipeDetailsModule(for: recipe)
    }
}

extension BaseRecipesPresenter: BaseRecipesInteractorOutput {
    /// Provides response from the interactor.
    /// - Parameters:
    ///   - response: ``Response`` got from the server.
    ///   - withOverridingCurrentData: defines whether this data show override current one. This is necessary for handling requesting random data (`true`) and data by provided url (`false`).
    public func didProvidedResponse(_ response: Response, withOverridingCurrentData: Bool) {
        var recipes = [Recipe]()
        
        guard let hits = response.hits else {
            handleError(.parsingJSONError)
            return
        }
        
        for hit in hits {
            guard let recipe = hit.recipe else {
                handleError(.parsingJSONError)
                return
            }
            recipes.append(recipe)
        }
        view?.fillData(with: recipes, nextPageUrl: response.links?.next?.href, withOverridingCurrentData: withOverridingCurrentData)
    }
    
    /// Provides data to show in alerts according to provided `error`.
    /// - Parameter error: ``NetworkManagerError`` error instance.
    public func handleError(_ error: NetworkManagerError) {
        switch error {
        case .invalidURL:
            view?.showAlert(title: Texts.Errors.oops, message: Texts.Errors.restartApp)
        case .retainCycle:
            view?.showAlert(title: Texts.Errors.oops, message: Texts.Errors.restartApp)
        case .networkError(let error):
            view?.showAlert(title: Texts.Errors.oops, message: "\(error.localizedDescription)")
        case .parsingJSONError:
            view?.showAlert(title: Texts.Errors.oops, message: Texts.Errors.somethingWentWrong)
        }
    }
}
