//
//  MainTabBarController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/23/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = UIColor(red: 23.0/255, green: 178.0/255, blue: 85.0/255, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor(red: 154.0/255, green: 167.0/255, blue: 182.0/255, alpha: 1.0)
    }

}
