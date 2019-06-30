//
//  ReviewSlider.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/29/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import Foundation
import UIKit

class ReviewSlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(x: 0, y: 7.5, width: bounds.width, height: 15.0)
        return rect
    }
    
    func setColour(score: Double) {
        self.maximumTrackTintColor = UIColor.white
        if score < 4.0 {
            self.minimumTrackTintColor = UIColor.init(red: 210.0/255, green: 45.0/255, blue: 45.0/255, alpha: 1.0) //Red
            self.thumbTintColor = UIColor.init(red: 210.0/255, green: 45.0/255, blue: 45.0/255, alpha: 1.0) //Red
        } else if score >= 4.0 && score <= 7.0 {
            self.minimumTrackTintColor = UIColor.init(red: 230.0/255, green: 230.0/255, blue: 0.0/255, alpha: 1.0) //Yellow
            self.thumbTintColor = UIColor.init(red: 230.0/255, green: 230.0/255, blue: 0.0/255, alpha: 1.0) //Yellow
        } else {
            self.minimumTrackTintColor = UIColor.init(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0) //Green
            self.thumbTintColor = UIColor.init(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0) //Green
        }
    }
    
}
