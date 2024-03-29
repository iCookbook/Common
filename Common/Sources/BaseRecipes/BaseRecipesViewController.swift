//
//  BaseRecipesViewController.swift
//  Pods
//
//  Created by Егор Бадмаев on 11.11.2022.
//  

import UIKit
import Models
import CommonUI
import Logger

/// `UIViewController` with collection view for recipes.
///
/// It has collection view with registered collection view cells:
/// * `RecipeCollectionViewCell`
/// * `LargeRecipeCollectionViewCell`
/// * `UsualCollectionViewCell`
/// And one footer (`UICollectionReusableView`): `LoadingCollectionViewFooter`
open class BaseRecipesViewController: UIViewController {
    
    // MARK: - Public Properties
    /// All properties were made `public` because of inheritance.
    
    /// Output of the view (Presenter).
    public let presenter: BaseRecipesViewOutput
    /// Array of recipes.
    public var data: [Recipe] = []
    
    /// Activity indicator for displaying loading.
    public let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.layer.zPosition = 2
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    /// Collection view with recipes.
    public lazy var recipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width - 32, height: view.frame.size.height * 0.38)
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        collectionView.register(UsualCollectionViewCell.self, forCellWithReuseIdentifier: UsualCollectionViewCell.identifier)
        collectionView.register(LargeRecipeCollectionViewCell.self, forCellWithReuseIdentifier: LargeRecipeCollectionViewCell.identifier)
        collectionView.register(LoadingCollectionViewFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingCollectionViewFooter.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    
    public init(presenter: BaseRecipesViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Open Methods
    
    /// Turns off all activity indicators and refresh controls, sets `isFetchingInProgress` to default value.
    open func resetAllActivity() {
        activityIndicator.stopAnimating()
        presenter.resetAllActivity()
    }
    
    /// Method responsible for turning offline mode on.
    ///
    /// It is empty, because every view controller turns offline mode in its' special way, but we need to call it from here.
    open func turnOnOfflineMode() {
    }
    
    /// Fills data for collection view.
    ///
    /// - Parameters:
    ///   - newData: new data to display.
    ///   - nextPageUrl: link to the next page.
    ///   - withOverridingCurrentData: defines whether this data show override current one. This is necessary for handling requesting random data (`true`) and data by provided url (`false`).
    ///
    /// - Note: method was declared in `BaseRecipesViewInput` protocol.
    open func fillData(with newData: [Recipe], withOverridingCurrentData: Bool) {
        if withOverridingCurrentData {
            // first setup or pull to refresh
            data = newData
        } else {
            // pagination
            data.append(contentsOf: newData)
        }
        
        self.resetAllActivity()
        
        UIView.transition(with: self.recipesCollectionView, duration: 0.55, options: .transitionCrossDissolve, animations: { [unowned self] in
            recipesCollectionView.reloadData()
        })
    }
}

extension BaseRecipesViewController: BaseRecipesViewInput {
    
    // MARK: - Public Methods
    
    /// Displays error with provided data.
    ///
    /// - Parameters:
    ///   - title: error title.
    ///   - message: error description.
    ///   - image: error image.
    public func displayError(title: String, message: String, image: UIImage?) {
        self.resetAllActivity()
        
        /// Opens custom alert.
        showAlert(title: title, message: message, image: image)
        
        /// If data was not provided, turn on offline mode.
        if self.data.isEmpty {
            self.turnOnOfflineMode()
        }
    }
}

// MARK: - UICollectionView

extension BaseRecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    /// Defined as `open` because we need to override this method in `DiscoverViewController`.
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeRecipeCollectionViewCell.identifier, for: indexPath) as? LargeRecipeCollectionViewCell else {
            fatalError("Could not cast cell at indexPath \(indexPath) to 'UsualCollectionViewCell' in 'Discover' module")
        }
        cell.configure(with: data[indexPath.row], dishOfTheDayLabelIsHidden: true)
        return cell
    }
    
    /// Defined as `open` because we need to override this method in our view controllers.
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// This method only shrinks recipe cell when it's been tapped.
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 1.4, initialSpringVelocity: 0.1, options: .allowUserInteraction, animations: {
            cell.transform = CGAffineTransform.identity
        })
        presenter.didSelectRecipe(data[indexPath.row])
    }
    
    // MARK: Footer
    
    /// Defined as `open` because we need to override this method in our view controllers.
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingCollectionViewFooter.identifier, for: indexPath) as? LoadingCollectionViewFooter else {
                fatalError("Could not cast to `LoadingCollectionViewFooter` for indexPath \(indexPath) in viewForSupplementaryElementOfKind")
            }
            return footer
        default:
            Logger.log("`default` case was called, but it should never be called", logType: .warning, shouldLogContext: true)
            return UICollectionReusableView() // empty view
        }
    }
    
    /// Defined as `open` because we need to override this method in our view controllers.
    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        switch elementKind {
        case UICollectionView.elementKindSectionFooter:
            guard let footer = view as? LoadingCollectionViewFooter else {
                fatalError("Could not cast to `LoadingCollectionViewFooter` for indexPath \(indexPath) in willDisplaySupplementaryView")
            }
            if presenter.willRequestDataForPagination() {
                footer.startActivityIndicator()
            }
        default:
            Logger.log("`default` case was called, but it should never be called", logType: .warning, shouldLogContext: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        switch elementKind {
        case UICollectionView.elementKindSectionFooter:
            guard let footer = view as? LoadingCollectionViewFooter else {
                fatalError("Could not cast to `LoadingCollectionViewFooter` for indexPath \(indexPath) in didEndDisplayingSupplementaryView")
            }
            footer.stopActivityIndicator()
        default:
            Logger.log("`default` case was called, but it should never be called", logType: .warning, shouldLogContext: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        /// If there is link to the next page, set size for footer, if not, set size for small inset.
        if presenter.willRequestDataForPagination() {
            return CGSize(width: view.frame.size.width, height: 60)
        } else {
            return CGSize(width: view.frame.size.width, height: 20)
        }
    }

}
