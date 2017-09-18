//
//  UICollectionViewCell.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

extension UICollectionViewCell {

    /// First get the enclosing collectionview
    /// then get the indexPath for this cell
    var indexPath: IndexPath? {
        return nearestSuperview(ofType: UICollectionView.self)?.indexPath(for: self)
    }
}
