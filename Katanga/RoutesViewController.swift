//
//  RoutesViewController.swift
//  Katanga
//
//  Created by Víctor Galán on 22/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RoutesViewController : UIViewController {
    
    //MARK: Private variables
    
    private var disposeBag = DisposeBag()
    
    private let activityIndicator = ActivityIndicator()
    
    
    //MARK: Outlets
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(RoutesCell.self)
            tableView.tableFooterView = UIView()
        }
    }
    
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.customizeTableView(withColor: .black)
        
        setupRx()
    }
    
    
    //MARK: Private methods
    
    private func setupRx() {
        KatangaBusApiClient().allRoutes()
            .trackActivity(activityIndicator)
            .scan([], accumulator: { $0 + [$1] })
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellType: RoutesCell.self)) { row, route, routeCell in
                routeCell.routeId = route.id
                routeCell.routeName = route.name
            }
            .addDisposableTo(disposeBag)
        
        activityIndicator
            .drive(spinner.rx.animating)
            .addDisposableTo(disposeBag)
    }
    
}
