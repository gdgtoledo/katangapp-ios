//
//  ViewController.swift
//  Katanga
//
//  Created by Víctor Galán on 9/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InitialViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var spinner: UIActivityIndicatorView?
    
    @IBOutlet weak var searchLocationButton: UIButton! {
        didSet {
            searchLocationButton.backgroundColor = .katangaYellow
            searchLocationButton.layer.cornerRadius = 30
            
            spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            spinner!.color = .black
            spinner!.center = CGPoint(x: 30, y: 30)

            searchLocationButton.addSubview(spinner!)
        }
    }

    @IBOutlet weak var metersSlider: UISlider!
    @IBOutlet weak var metersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRx()
    }
    
    private func setUpRx() {
        metersSlider.rx.value
            .startWith(500)
            .map {"\(Int($0))"}
            .bindTo(metersLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        searchLocationButton.rx.tap
            .bindNext {
                self.spinner?.startAnimating()
                self.performSegue(withIdentifier: "shownearstops", sender: nil)
            }
            .addDisposableTo(disposeBag)
    }
}

