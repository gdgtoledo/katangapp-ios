//
//  AppDelegate.swift
//  Katanga
//
//  Created by Víctor Galán on 9/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .katangaYellow
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.katangaYellow]
        
        UITabBar.appearance().tintColor = .katangaYellow
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white],  for: .normal)
        
        return true
    }
}

