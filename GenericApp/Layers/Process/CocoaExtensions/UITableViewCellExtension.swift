//
//  UITableViewCellExtension.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

extension UITableViewCell {

    /// First get the enclosing tableview
    /// then get the indexPath for this cell
    var indexPath: IndexPath? {
        return nearestSuperview(ofType: UITableView.self)?.indexPath(for: self)
    }
}
