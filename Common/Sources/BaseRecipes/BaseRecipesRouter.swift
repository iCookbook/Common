//
//  BaseRecipesRouter.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  

import UIKit
import Models
import RecipeDetails

open class BaseRecipesRouter {
    public weak var presenter: BaseRecipesRouterOutput?
    public weak var viewController: UIViewController?
    
    /// We need to use `public` initializer to create it's instance inside modules assemblies.
    public init() {}
}

extension BaseRecipesRouter: BaseRecipesRouterInput {
    /// Opens details module for provided recipe.
    ///
    /// - Parameter recipe: `Recipe` instance open details with.
    public func openRecipeDetailsModule(for recipe: Recipe) {
        let context = RecipeDetailsContext(moduleOutput: self, recipe: recipe)
        let assembly = RecipeDetailsAssembly.assemble(with: context)
        // hides tab bar
        assembly.viewController.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(assembly.viewController, animated: true)
    }
}

extension BaseRecipesRouter: RecipeDetailsModuleOutput {
}
