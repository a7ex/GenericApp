//
//  DeepLinkExtension.swift

import UIKit

enum InterceptedURLs: Equatable {
    case applyActionCode(actionCode: String)
    case showOrder(orderNumber: String)
    case reopenCart
    
    init?(urlString: String) {
        if urlString.contains(InterceptedURLs.applyActionCode(actionCode: "").interceptIdentifier()) {
            let parts = urlString.components(separatedBy: InterceptedURLs.applyActionCode(actionCode: "").interceptIdentifier())
            guard parts.count > 1 else { return nil }
            let moreParts = parts[1].components(separatedBy: "&")
            self = InterceptedURLs.applyActionCode(actionCode: moreParts.first!)
        } else if urlString.contains(InterceptedURLs.showOrder(orderNumber: "").interceptIdentifier()) {
            let parts = urlString.components(separatedBy: InterceptedURLs.showOrder(orderNumber: "").interceptIdentifier())
            guard parts.count > 1 else { return nil }
            let moreParts = parts[1].components(separatedBy: "&")
            self = InterceptedURLs.showOrder(orderNumber: moreParts.first!)
        } else {
            return nil
        }
    }
    
    func interceptIdentifier() -> String {
        switch self {
        case .applyActionCode:
            return "cart.html?ac="
        case .showOrder:
            return "/account/orders.html?orderNumber="
        case .reopenCart:
            return "reopencart"
        }
    }
    
    func correctedURLString() -> String {
        switch self {
        case .reopenCart:
            return "https://this.is.an.example/index.reopencart.html"
        default:
            return ""
        }
    }
}

func == (lhs: InterceptedURLs, rhs: InterceptedURLs) -> Bool {
    switch lhs {
    case .applyActionCode(let actionCode):
        switch rhs {
        case .applyActionCode(let actionCodeL):
            return actionCode == actionCodeL
        default:
            return false
        }
    case .showOrder(let orderNumber):
        switch rhs {
        case .showOrder(let orderNumberL):
            return orderNumber == orderNumberL
        default:
            return false
        }
    case .reopenCart:
        switch rhs {
        case .reopenCart:
            return true
        default:
            return false
        }
    }
}


extension UIViewController {
    private static let customURLScheme = "customScheme"
    func handleDeepLink(_ url: URL) -> Bool {
        guard url.scheme?.hasPrefix(UIViewController.customURLScheme) == true,
            let host = url.host else {
                return false
        }
        let urlParamDictionary = url.urlParamDictionary
        switch host {
        // Example:
        case "product":
            if let productNumber = urlParamDictionary["productNumber"] {
                print("Show the product with the productNumber \(productNumber).")
            }
        case "cart":
            break
        default:
            break
        }
        return true
    }
    
    func interceptUrl(_ url: String) -> Bool {
        guard let urlInterceptor = InterceptedURLs(urlString: url) else { return false }
        
        switch urlInterceptor {
        case .showOrder(let orderNumber):
            print("Show the order with the ordernumber \(orderNumber) inline.")
            return true
        default:
            break
        }
        return false
    }
    
    func handleURLString(_ urlString: String, fallBackUrlString: String?=nil) {
        // allow for any hackery with the URL...
        guard !interceptUrl(urlString) else { return }
        // ...now do the standard behavior
        openURLInBrowser(urlString, promptUser: "")
    }
}
