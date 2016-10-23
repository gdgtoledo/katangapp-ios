//
//  UITableView+Katanga.swift
//  Katanga
//
//  Created by Víctor Galán on 23/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit


extension UITableView {
    
    func register<T: UITableViewCell>(_ : T.Type) where T: NibLoadableView, T: ReusableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}
