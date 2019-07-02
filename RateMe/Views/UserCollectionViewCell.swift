//
//  UserCollectionViewCell.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/23/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit
import Kingfisher

protocol UserReviewDelegate {
    func didRequestToReview(cell: UICollectionViewCell)
}

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    var userReviewDelegate: UserReviewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCornerRadius()
        styleCardView()
    }
    
    func applyCornerRadius() {
        reviewButton.layer.cornerRadius = 8
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = photoImage.frame.height / 2
        photoImage.clipsToBounds = true
        
    }
    
    func styleCardView() {
        cardView.layer.backgroundColor = UIColor(red: 250.0, green: 250.0, blue: 250.0, alpha: 1.0).cgColor
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowOpacity = 0.75
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.masksToBounds = false
    }
    
    func setData(user: User) {
        if let fullName = user.fullName as String?, let age = user.age as Int?, let gender = user.gender as String? {
            nameLabel.text = fullName
            ageLabel.text = "Age: " + String(age)
            genderLabel.text = "Gender: " + gender
        }
        if let photoUrl = user.photoUrl as String? {
            photoImage.kf.setImage(with: URL(string: photoUrl))
        } else {
            photoImage.image = UIImage(named: "avatar")
        }
    }
    
    
    @IBAction func didPressReview(_ sender: Any) {
        userReviewDelegate?.didRequestToReview(cell: self)
    }
    
}
