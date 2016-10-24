//
//  UITableView+Katanga.swift
//  Katanga
//
//  Created by Víctor Galán on 23/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITableView {
    
    func register<T: UITableViewCell>(_ : T.Type) where T: NibLoadableView, T: ReusableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}


extension Reactive where Base : UITableView {
    
    func items<S: Sequence, Cell: UITableViewCell, O : ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable
        where O.E == S, Cell : ReusableView {
            
        return items(cellIdentifier: cellType.reuseIdentifier, cellType: cellType)
    }
}

extension UITableView {
    
    func customizeTableView(withColor color: UIColor) {
        backgroundColor = color
        separatorColor = color
        
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
}
