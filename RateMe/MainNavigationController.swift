//
//  MainNavigationController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/23/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = UIColor(red: 23.0/255, green: 178.0/255, blue: 85.0/255, alpha: 1.0)
    }
}

class ProfileNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor(red: 23.0/255, green: 178.0/255, blue: 85.0/255, alpha: 1.0)
    }
}

class InitialNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
