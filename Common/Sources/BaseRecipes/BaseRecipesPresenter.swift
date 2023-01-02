//
//  BaseRecipesPresenter.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  

import Models
import Networking
import Resources

open class BaseRecipesPresenter {
    
    // MARK: - Public Properties
    
    public weak var view: BaseRecipesViewInput?
    public weak var moduleOutput: BaseRecipesModuleOutput?
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
    
    public func requestData(urlString: String?) {
        /// Because it is _event handling_, we need to use `userInteractive` quality of service.
        DispatchQueue.global(qos: .userInteractive).async {
            self.interactor.provideData(urlString: urlString)
        }
    }
    
    public func didSelectRecipe(_ recipe: Recipe) {
        router.openRecipeDetailsModule(for: recipe)
    }
}

extension BaseRecipesPresenter: BaseRecipesInteractorOutput {
    /// Provides response from the interactor.
    /// 
    /// - Parameters:
    ///   - response: `Response` got from the server.
    ///   - withOverridingCurrentData: defines whether this data show override current one. This is necessary for handling requesting random data (`true`) and data by provided url (`false`).
    public func didProvidedResponse(_ response: Response, withOverridingCurrentData: Bool) {
        var recipes = [Recipe]()
        
        for hit in response.hits ?? [] {
            guard let recipe = hit.recipe else { return } // else do nothing
            // adds description of the recipe
            recipe.description = Texts.RecipeDetails.description(name: recipe.label ?? Texts.Discover.mockRecipeTitle, index: recipes.count)
            recipes.append(recipe)
        }
        view?.fillData(with: recipes, nextPageUrl: response.links?.next?.href, withOverridingCurrentData: withOverridingCurrentData)
    }
    
    /// Provides data to show in alerts according to provided `error`.
    ///
    /// - Parameter error: `NetworkManagerError` error instance.
    public func handleError(_ error: NetworkManagerError) {
        DispatchQueue.main.async {
            switch error {
            case .invalidURL:
                self.view?.displayError(title: Texts.Errors.oops, message: Texts.Errors.somethingWentWrong, image: Resources.Images.Errors.network)
            case .retainCycle:
                self.view?.displayError(title: Texts.Errors.oops, message: Texts.Errors.restartApp, image: Resources.Images.Errors.network)
            case .invalidResponse:
                self.view?.displayError(title: Texts.Errors.networkError, message: Texts.Errors.networkErrorDescription, image: Resources.Images.Errors.network)
            case .unsuccessfulStatusCode(let statusCode):
                self.view?.displayError(title: "\(Texts.Errors.error) \(statusCode.rawValue)", message: Texts.Errors.somethingWentWrong, image: Resources.Images.Errors.network)
            case .networkError(let error):
                self.view?.displayError(title: Texts.Errors.networkError, message: "\(error.localizedDescription)", image: Resources.Images.Errors.network)
            case .decodingError:
                #warning("По вашему запросу ничего не найдено")
                self.view?.displayError(title: Texts.Errors.serverError, message: Texts.Errors.somethingWentWrong, image: Resources.Images.Errors.network)
            }
        }
    }
}
