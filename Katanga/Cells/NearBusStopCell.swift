//
//  TableViewCellTest.swift
//  testTables
//
//  Created by Víctor Galán on 21/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NearBusStopCell: UITableViewCell {
    
    
    //MARK: Public variables
    
    public var items: [BusStopTime] {
        set {
            _items.value.append(contentsOf: newValue)
        }
        get {
            return _items.value
        }
    }
    
    public var busStopName: String {
        set {
            busStopNameLabel.text = newValue
        }
        get {
            return busStopNameLabel.text ?? ""
        }
    }
    
    public var distance: String {
        set {
            distanceLabel.text = newValue
        }
        get {
            return distanceLabel.text ?? ""
        }
    }
    
    
    //MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "BusComingCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "cell")
            
            tableView.rowHeight = Constants.rowHeight
        }
    }
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = Constants.cornerRadius
            containerView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet private weak var busStopNameLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: Private vars
    
    private var disposeBag = DisposeBag()
    private var _items = Variable<[BusStopTime]>([])
    
    private struct Constants {
        static let cornerRadius: CGFloat = 10
        static let rowHeight: CGFloat = 40
    }
    
    
    //MARK: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        
        setupRx()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        _items.value = []
        
        setupRx()
    }
    
    
    //MARK: Private methods
    
    private func setupRx() {
        
        _items
            .asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: "cell", cellType: BusComingCell.self)) { row, element, cell in
                cell.routeId = element.id
                cell.time = element.minutes
            }.addDisposableTo(disposeBag)
        
        _items
            .asObservable()
            .map { CGFloat($0.count) }
            .filter { $0 > 0 }
            .map {  $0 * Constants.rowHeight + self.headerHeightConstraint.constant }
            .bindTo(heightConstraint.rx.constant)
            .addDisposableTo(disposeBag)
    }
}