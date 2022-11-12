//
//  BaseRecipesInteractor.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  
//

import Foundation

open class BaseRecipesInteractor {
    weak var output: BaseRecipesInteractorOutput?
}

extension BaseRecipesInteractor: BaseRecipesInteractorInput {
}
