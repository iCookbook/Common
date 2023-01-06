//
//  BaseRecipesInteractor.swift
//  Common
//
//  Created by Егор Бадмаев on 26.12.2022.
//

extension String {
    /// Capitalizes first letter of the string
    public func capitalizedFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
