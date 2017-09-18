//
//  ViewController.swift
//
//  Created by Alex da Franca on 16.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

extension UIViewController {
    final func showSimpleAlert(_ message: String) {
        let alrt = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alrt.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in

        }))
        present(alrt, animated: true, completion: nil)
    }

    final func viewControllerById(_ identifier: String, storyBoard storyboardName: String) -> UIViewController? {
        guard Bundle.main.path(forResource: storyboardName, ofType: "storyboardc") != nil else { return nil }
        let sourceStoryBoard = UIStoryboard(name: storyboardName, bundle: nil)
        return identifier.isEmpty ?
            sourceStoryBoard.instantiateInitialViewController():
            sourceStoryBoard.instantiateViewController(withIdentifier: identifier)
    }

    final func getTopControllersIfContainerVC() -> [UIViewController] {
        if let navCtrl = self as? UINavigationController {
            if let top = navCtrl.visibleViewController {
                return [top]
            } else if let top = navCtrl.viewControllers.last {
                return [top]
            }
        }
        if let splitCtrl = self as? UISplitViewController {
            var vctrls = [UIViewController]()
            if let thisCtrl = splitCtrl.getMasterTopController() {
                vctrls.append(thisCtrl)
            }
            if let thisCtrl = splitCtrl.getDetailTopController() {
                vctrls.append(thisCtrl)
            }
            return vctrls
        }
        return [self]
    }
}
