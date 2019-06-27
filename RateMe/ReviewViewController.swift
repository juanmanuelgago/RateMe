//
//  ReviewViewController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/26/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    var evaluatedUser: User?
    var reviewType: ReviewType?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("USUARIO!")
        print(evaluatedUser!)
        print("----")
        print("REVIEWTYPE!")
        print(reviewType!)
        print("----")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
