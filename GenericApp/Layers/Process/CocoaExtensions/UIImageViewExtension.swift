//
//  UIImageViewExtension.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit
// import Haneke

extension UIImageView {

    // this is not in use at the moment. It was a temporary hack to address a server issue
    func setImageFromUrl(_ url: URL, placeholder: UIImage? = nil, format: String? = nil, failure fail: ((Error?) -> Void)? = nil, success succeed: ((UIImage) -> Void)? = nil) {

        // the value for the User-Agent in iOS Apps usually defaults to something like:
        // <AppName>/<Buildnumber> CFNetwork/<version number> Darwin/<version number>
        // so in our case, when the buildnumber is 23, it would be:
        //        "Conrad/23 CFNetwork/711.5.6 Darwin/14.0.0"

        // for the user agent we send with each request
        // we want to know the idiom, whether it is iPhone or iPad
        // so we get it here from our traitcollection

        var mutableURLRequest = URLRequest(url: url)
        let headerParams = ConfigValues.standardHTTPHeaderParameters()
        for (key, value) in headerParams {
            mutableURLRequest.setValue(value, forHTTPHeaderField: key)
        }

//        let defaultFormat = Format<UIImage>(name: "images", diskCapacity: HanekeGlobals.UIKit.DefaultFormat.DiskCapacity) { image in
//            return image
//        }

//        self.hnk_setImageFromRequest(request: mutableURLRequest, placeholder: placeholder, format: format ?? defaultFormat, failure: fail, success: succeed)
    }

    func setUncachedImageFromUrl(_ url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        let identifier = String(format:"%p", self)
        RemoteImageLoader.sharedInstance.lastAssignedURLs[identifier] = url.absoluteString

        var mutableURLRequest = URLRequest(url: url)
        let headerParams = ConfigValues.standardHTTPHeaderParameters()
        for (key, value) in headerParams {
            mutableURLRequest.setValue(value, forHTTPHeaderField: key)
        }
        mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData

        URLSession.shared.dataTask(with: mutableURLRequest, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode < 400,
                //                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data,
                error == nil,
                let image = UIImage(data: data)
                else { return }
            if RemoteImageLoader.sharedInstance.lastAssignedURLs[identifier] == url.absoluteString {
                DispatchQueue.main.async { () -> Void in
                    self.image = image
                }
            }
        }).resume()
    }
}

private class RemoteImageLoader {
    static let sharedInstance = RemoteImageLoader()
    fileprivate final var lastAssignedURLs = [String: String]()
}
