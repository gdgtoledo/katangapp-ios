//
//  BaseListViewController.swift
//  Katanga
//
//  Created by Victor Galán on 07/11/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol DataListTableView {

    associatedtype Model
    associatedtype CellType: UITableViewCell
    
    func fillCell(row: Int, element: Model, cell: CellType)
}

extension DataListTableView where CellType : NibLoadableView & ReusableView {
    
    func bindViewModel(tableView: UITableView, driver: Driver<[Model]>) -> Disposable {
        
        return driver.drive(tableView.rx.items(cellType: CellType.self)) { row, element, cell in
            self.fillCell(row: row, element: element, cell: cell)
        }
    }
    
    func initialize(tableView: UITableView) {
        tableView.register(CellType.self)
        
        tableView.customizeTableView(withColor: .black)
        
        tableView.tableFooterView = UIView()
        
        tableView.separatorStyle = .none
    }
}
