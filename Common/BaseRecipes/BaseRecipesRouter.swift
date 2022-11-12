//
//  BaseRecipesRouter.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  
//

import UIKit
import RecipeDetails

open class BaseRecipesRouter {
    weak var output: BaseRecipesRouterOutput?
    weak var viewController: UIViewController?
}

extension BaseRecipesRouter: BaseRecipesRouterInput {
    /// Opens details module for provided recipe
    /// - Parameter recipe: ``Recipe`` instance open details with.
    func openRecipeDetailsModule(for recipe: Recipe) {
        let context = RecipeDetailsContext(moduleOutput: self, recipe: recipe)
        let assembly = RecipeDetailsAssembly.assemble(with: context)
        // hides tab bar
        assembly.viewController.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(assembly.viewController, animated: true)
    }
}

extension BaseRecipesRouter: RecipeDetailsModuleOutput {
}
