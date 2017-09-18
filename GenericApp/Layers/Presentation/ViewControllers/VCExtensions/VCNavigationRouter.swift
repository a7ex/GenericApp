//
//  VCNavigationRouter.swift

import UIKit

/// Routable Protocol defines functions to present or push a Viewcontroller
/// which can be referenced by two enum valus: Storyboard name and Scene Identifier
///

extension UIViewController: Routable {
    enum StoryboardIdentifier: String {
        case main = "Main"
    }
    enum StoryboardSceneIdentifier: String {
        case initialViewController = "__internal_initialViewController"
    }
}

protocol Routable {
    associatedtype StoryboardIdentifier: RawRepresentable
    associatedtype StoryboardSceneIdentifier: RawRepresentable

    func presentVC<T: UIViewController>(
        storyboard: StoryboardIdentifier,
        identifier: StoryboardSceneIdentifier?,
        animated: Bool,
        modalPresentationStyle: UIModalPresentationStyle?,
        configure: ((T) -> Void)?,
        completion: ((T) -> Void)?)

    func showVC<T: UIViewController>(
        storyboard: StoryboardIdentifier,
        identifier: StoryboardSceneIdentifier?,
        configure: ((T) -> Void)?)

    func showDetailVC<T: UIViewController>(
        storyboard: StoryboardIdentifier,
        identifier: StoryboardSceneIdentifier?,
        configure: ((T) -> Void)?)
}

extension Routable where Self: UIViewController {

    /**
     Presents the intial view controller of the specified storyboard modally.

     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter configure: Configure the view controller before it is loaded.
     - parameter completion: Completion the view controller after it is loaded.
     */
    func presentVC<T: UIViewController>(
        storyboard: StoryboardIdentifier,
        identifier: StoryboardSceneIdentifier? = nil,
        animated: Bool = true,
        modalPresentationStyle: UIModalPresentationStyle? = nil,
        configure: ((T) -> Void)? = nil,
        completion: ((T) -> Void)? = nil) {

        guard let vc = instantiateAndConfigureViewController(storyboardIdentifier: storyboard, identifier: identifier, configure: configure) else {
            return
        }
        if let modalPresentationStyle = modalPresentationStyle {
            vc.modalPresentationStyle = modalPresentationStyle
        }
        present(vc, animated: animated) {
            completion?(vc)
        }
    }

    /**
     Present the intial view controller of the specified storyboard in the primary context.
     Set the initial view controller in the target storyboard or specify the identifier.

     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter configure: Configure the view controller before it is loaded.
     */
    func showVC<T: UIViewController>(
        storyboard: StoryboardIdentifier,
        identifier: StoryboardSceneIdentifier? = nil,
        configure: ((T) -> Void)? = nil) {

        guard let vc = instantiateAndConfigureViewController(storyboardIdentifier: storyboard, identifier: identifier, configure: configure) else {
            return
        }
        show(vc, sender: self)
    }

    /**
     Present the intial view controller of the specified storyboard in the secondary (or detail) context.
     Set the initial view controller in the target storyboard or specify the identifier.

     - parameter storyboard: Storyboard name.
     - parameter identifier: View controller name.
     - parameter configure: Configure the view controller before it is loaded.
     */
    func showDetailVC<T: UIViewController>(
        storyboard: StoryboardIdentifier,
        identifier: StoryboardSceneIdentifier? = nil,
        configure: ((T) -> Void)? = nil) {

        guard let vc = instantiateAndConfigureViewController(storyboardIdentifier: storyboard, identifier: identifier, configure: configure) else {
            return
        }
        showDetailViewController(vc, sender: self)
    }

    // MARK: - Private

    func instantiateAndConfigureViewController<T: UIViewController>(
        storyboardIdentifier: StoryboardIdentifier,
        identifier: StoryboardSceneIdentifier?,
        configure: ((T) -> Void)? = nil) -> T? {

        let storyboard = UIStoryboard(name: storyboardIdentifier.rawValue)
        let identifierString = identifier?.rawValue
        guard let controller = storyboard.viewController(withIdentifier: identifierString) as? T else {
            assertionFailure("Unable to instantiate controller for storyboard \(storyboardIdentifier.rawValue) with identifier \(identifierString ?? "InitialViewController").")
            return nil
        }
        configure?(controller)
        return controller
    }
}

extension UIStoryboard {
    /**
     Instantiates a Viewcontroller from a given storyboard either by sceneId or taking the initial vc

     - parameter identifier: The sceneId of the ViewController Scene in the storyboard. If missing or empty instantiateInitialViewController() is called instead and returns the initial ViewController defined in the storyboard

     - returns: A ViewController (or its subclass) for the specified identifier.
     */
    func viewController(withIdentifier identifier: String?) -> UIViewController? {
        if let identifier = identifier,
            !identifier.isEmpty,
            identifier != BaseVC.StoryboardSceneIdentifier.initialViewController.rawValue {
            return instantiateViewController(withIdentifier: identifier)
        } else {
            return instantiateInitialViewController()
        }
    }

    /**
     Creates and returns a storyboard object for the specified storyboard resource file in the main bundle of the current application.

     - parameter name: The name of the storyboard resource file without the filename extension.

     - returns: A storyboard object for the specified file. If no storyboard resource file matching name exists, an exception is thrown.
     */
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
}

extension UIViewController {
    /**
     Show a viewcontroller (modal, if there is no navigationb controller or push, if there is a navigation controller^)
     
     - parameter vc: UIViewController instance to push
     - parameter replaceControllers: replace all controllers in navigation, using for presentation in iPad detail view
     */
    final func showViewControllerInDetailsSplit(_ vc: UIViewController, replaceControllers: Bool? = false) {
        if let splitVC = splitViewController {
            if splitVC.isCollapsed {
                self.splitViewController?.showDetailViewController(vc, sender: nil)
            } else {
                let navController = UINavigationController(rootViewController: vc)
                self.splitViewController?.showDetailViewController(navController, sender: nil)
            }
        } else {
            show(vc, sender: nil)
        }
    }
}
