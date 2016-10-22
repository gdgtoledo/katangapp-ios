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
    
    var disposeBag = DisposeBag()
    let activityIndicator = ActivityIndicator()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "RoutesCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "cell")
            tableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KatangaBusApiClient().allRoutes()
            .trackActivity(activityIndicator)
            .scan([], accumulator: { $0 + [$1] })
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "cell", cellType: RoutesCell.self)) { row, route, routeCell in
                routeCell.routeId = route.id
                routeCell.routeName = route.name
            }
            .addDisposableTo(disposeBag)
        
        activityIndicator
            .drive(spinner.rx.animating)
            .addDisposableTo(disposeBag)
    }
    
}
