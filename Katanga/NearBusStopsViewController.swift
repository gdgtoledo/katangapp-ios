//
//  NearBusStopsViewController.swift
//  Katanga
//
//  Created by Víctor Galán on 23/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NearBusStopsViewController: UIViewController {
    
    
    //MARK: Private variables
    
    private var disposeBag = DisposeBag()
    private var refreshControlBag = DisposeBag()
    
    private let activityIndicator = ActivityIndicator()
    
    private var nearBusStops: Driver<[NearBusStop]>?
    
    private var refreshControl: UIRefreshControl?
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(NearBusStopCell.self)
            tableView.tableFooterView = UIView()
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 200
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }
    
    //MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefresh()
        
        tableView.customizeTableView(withColor: .black)
        
        nearBusStops = KatangaBusApiClient()
                .nearbyBusStops(latitude: 39.861293, longitude: -4.026146, meters: 1000)
                .trackActivity(activityIndicator)
                .scan([], accumulator: { $0 + [$1] })
                .asDriver(onErrorJustReturn: [])
        
        setupRx()
    }
    
    
    //MARK: Private methods
    
    private func setupRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .katangaYellow
        
        refreshControl?.rx.controlEvent(.valueChanged)
            .bindNext { [weak self] in
                self?.disposeBag = DisposeBag()
                self?.setupRx()
            }
            .addDisposableTo(refreshControlBag)
        
        tableView.addSubview(refreshControl!)
        
        activityIndicator
            .drive(refreshControl!.rx.refreshing)
            .addDisposableTo(refreshControlBag)
    }
    
    private func setupRx() {
    
            nearBusStops?.drive(tableView.rx.items(cellType: NearBusStopCell.self)) { row, nearBusStop, cell in
                cell.busStopName = nearBusStop.busStop.address
                
                let distanceFormatted = String(format: "%.2f", nearBusStop.distance)
                cell.distance = "(\(distanceFormatted) metros)"
                
                cell.items = nearBusStop.times
            }
            .addDisposableTo(disposeBag)
        
        activityIndicator
            .drive(spinner.rx.animating)
            .addDisposableTo(disposeBag)
    }
}
