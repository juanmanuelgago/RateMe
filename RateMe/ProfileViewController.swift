//
//  ProfileViewController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/16/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var circularScoreView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var userReviewsLabel: UILabel!
    
    var user: User?
    var reviews: [Review]?
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyCornerRadius()
        applyCardStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let loggedUser = AuthenticationManager.shared.loggedUser as User? {
            startActivityIndicator()
            user = loggedUser
            assignUserScore()
            assignReviewsQuantity()
            assignUserData()
        }
    }
    
    func startActivityIndicator() {
        let newView = UIView(frame: UIScreen.main.bounds)
        newView.tag = 101 // Random tag, for the process of dismissing the view.
        newView.backgroundColor = .white
        newView.alpha = 1
        self.view.addSubview(newView)
        newView.addSubview(activityIndicator)
        activityIndicator.center = newView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.startAnimating()
    }
    
    // Stop the loader activity.
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        if let viewTag = self.view.viewWithTag(101) {
            viewTag.removeFromSuperview()
        }
    }
    
    func assignUserScore() {
        DatabaseManager.shared
            .getAverageFromReviews { (averageResult, err) in
                if let _ = err {
                    self.stopActivityIndicator()
                    self.userScoreLabel.text = "?"
                } else {
                    if let result = averageResult as Double? {
                        self.stopActivityIndicator()
                        let resultWithOneDecimal = round(result * 10) / 10
                        self.userScoreLabel.text = String(resultWithOneDecimal)
                        self.styleCircleProgressBar(score: resultWithOneDecimal)
                    }
                    
                }
        }
    }
    
    func assignReviewsQuantity() {
        DatabaseManager.shared
            .getReviewsOfUser { (quantityReviews, err) in
                if let _ = err {
                    self.userReviewsLabel.text = ""
                } else {
                    if let result = quantityReviews as Int? {
                        if result == 1 {
                            self.userReviewsLabel.text = "Score of 1 review."
                        } else if result > 1 {
                            self.userReviewsLabel.text = "Score of " + String(result) +
                            " reviews."
                        } else {
                            self.userReviewsLabel.text = "No reviews detected."
                        }
                    }
                }
        }
    }
    
    func assignUserData() {
        userNameLabel.text = user?.fullName!
        userAgeLabel.text = String(user!.age!)
        userGenderLabel.text = user?.gender!
        userEmailLabel.text = user?.email!
        if let photoUrl = user?.photoUrl as String? {
            userImageView.kf.setImage(with: URL(string: photoUrl))
        }
    }
    
    func applyCornerRadius() {
        logOutButton.layer.cornerRadius = 8
        cardView.layer.cornerRadius = 8
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.clipsToBounds = true
    }
    
    func applyCardStyle() {
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowOpacity = 0.75
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.masksToBounds = false
    }
    
    func styleCircleProgressBar(score: Double) {
        
        let shapeLayer = CAShapeLayer()
        let trackLayer = CAShapeLayer()
        
        let centerPoint = CGPoint(x: circularScoreView.bounds.width / 2, y: circularScoreView.bounds.width / 2)
        let circleRadius = CGFloat(circularScoreView.bounds.width / 2 * 0.83)
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        //For the shape behind the progress bar, used as the track path for the bar.
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.fillColor = UIColor.white.cgColor
        trackLayer.lineCap = kCALineCapRound
        trackLayer.lineWidth = 5
        
        
        // For the shape of the progress bar over the track layer.
        shapeLayer.path = circularPath.cgPath
        if score < 4.0 {
            shapeLayer.strokeColor = UIColor.init(red: 210.0/255, green: 45.0/255, blue: 45.0/255, alpha: 1.0).cgColor
            userScoreLabel.textColor = UIColor.init(red: 210.0/255, green: 45.0/255, blue: 45.0/255, alpha: 1.0)
        } else if score >= 4.0 && score <= 7.0 {
            shapeLayer.strokeColor = UIColor.init(red: 230.0/255, green: 230.0/255, blue: 0.0/255, alpha: 1.0).cgColor
            userScoreLabel.textColor = UIColor.init(red: 230.0/255, green: 230.0/255, blue: 0.0/255, alpha: 1.0)
        } else {
            shapeLayer.strokeColor = UIColor.init(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0).cgColor
            userScoreLabel.textColor = UIColor.init(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0)
        }
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        
        // Animation of the progress bar. Three seconds.
        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimation.toValue = score/10
        progressAnimation.duration = 2.5
        progressAnimation.fillMode = kCAFillModeForwards
        progressAnimation.isRemovedOnCompletion = false
        
        circularScoreView.layer.addSublayer(trackLayer)
        shapeLayer.add(progressAnimation, forKey: "progressAnimationKey")
        circularScoreView.layer.addSublayer(shapeLayer)
        circularScoreView.bringSubview(toFront: userScoreLabel)
    }
    
    @IBAction func didPressLogOut(_ sender: Any) {
        AuthenticationManager.shared.logout { (result, error) in
            if let _ = error {
                print("No me pude desloguear.")
            } else {
                if let result = result as Bool? {
                    if result {
                        
                    } else {
                        print("No me pude desloguear")
                    }
                }
            }
        }
    }
    
}
