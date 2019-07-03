//
//  ReviewViewController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/26/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    
    @IBOutlet weak var reviewDescriptionLabel: UILabel!
    @IBOutlet var reviewQuestions: [UILabel]!
    @IBOutlet var reviewSliders: [ReviewSlider]!
    @IBOutlet var reviewScores: [UILabel]!
    
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var isAnonymousSwitch: UISwitch!
    @IBOutlet weak var finishButton: UIButton!
    
    var newReview: Review?

    override func viewDidLoad() {
        super.viewDidLoad()
        applyCornerRadius()
        
        //Listen to Keyboard events.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true // Hides the tabbar in this view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        if let newReview = newReview as Review?, let name = newReview.reviewType.name as String? {
            self.navigationItem.title = name
        } else {
            self.navigationItem.title = "Review"
        }
        initializeReviewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false // Prepare the tabs not to be hidden.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func applyCornerRadius() {
        finishButton.layer.cornerRadius = 8
        commentsTextView.layer.cornerRadius = 8
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
    }
    
    func initializeReviewData() {
        if let newReview = newReview as Review? {
            // Data of the user evaluated.
            userNameLabel.text = newReview.userTo.fullName
            userAgeLabel.text = String(newReview.userTo.age!) + " years"
            userGenderLabel.text = newReview.userTo.gender
            if let photoUrl = newReview.userTo.photoUrl as String? {
                userImage.kf.setImage(with: URL(string: photoUrl))
            }
            
            // Assign the questions and the description to their labels.
            reviewDescriptionLabel.text = newReview.reviewType.description
            if let questions = newReview.reviewType.questions as [String]? {
                for i in 0..<questions.count {
                    reviewQuestions[i].text = questions[i]
                }
            }
            
            // Assign the values to the score labels.
            // Initially, is 5 in all sliders.
            for scoreSlider in reviewSliders {
                reviewScores[scoreSlider.tag].text = String(Double(scoreSlider.value))
                updateColourOfLabel(indexOfLabel: scoreSlider.tag, score: Double(scoreSlider.value))
                updateColourOfSlider(indexOfSlider: scoreSlider.tag, score: Double(scoreSlider.value))
            }
        }
    }
    
    func updateColourOfSlider(indexOfSlider: Int, score: Double) {
        let sliderToChange = reviewSliders[indexOfSlider]
        sliderToChange.setColour(score: score)
    }
    
    func updateColourOfLabel(indexOfLabel: Int, score: Double) {
        let labelToChange = reviewScores[indexOfLabel]
        if score < 4.0 {
            labelToChange.textColor = UIColor.init(red: 210.0/255, green: 45.0/255, blue: 45.0/255, alpha: 1.0) //Red
        } else if score >= 4.0 && score <= 7.0 {
            labelToChange.textColor = UIColor.init(red: 230.0/255, green: 230.0/255, blue: 0.0/255, alpha: 1.0) //Yellow
        } else {
            labelToChange.textColor = UIColor.init(red: 0.0/255, green: 179.0/255, blue: 60.0/255, alpha: 1.0) //Green
        }
    }
    
    @objc func keyboardWillAppear(notification: Notification) {
        scrollView.frame.origin.y = -200
    }
    
    @objc func keyboardWillDisappear(notification: Notification) {
        scrollView.frame.origin.y = 0
    }
    
    @IBAction func didChangeSlider(_ sender: UISlider) {
        let index = sender.tag
        let score = reviewSliders[index].value
        let doubleScore = Double(score)
        let roundedDoubleScore = round(doubleScore * 10) / 10
        reviewScores[index].text = String(roundedDoubleScore)
        newReview?.assignScore(value: roundedDoubleScore, index: index)
        updateColourOfLabel(indexOfLabel: index, score: roundedDoubleScore)
        updateColourOfSlider(indexOfSlider: index, score: roundedDoubleScore)
    }
    
    @IBAction func didChangeSwitch(_ sender: Any) {
        if isAnonymousSwitch.isOn {
            newReview?.assignIsAnonymous(value: true)
        } else {
            newReview?.assignIsAnonymous(value: false)
        }
    }
    
    @IBAction func didPressFinish(_ sender: Any) {
        if let newReview = newReview as Review? {
            newReview.comments = commentsTextView.text
            DatabaseManager.shared.addReview(review: newReview) { (result, error) in
                if let _ = error {
                    print("No se subió la review.")
                } else {
                    if result! {
                        let alert = UIAlertController(title: "Successful review.", message: "Your review has been created.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("Teóricamente no.")
                    }
                }
            }
        }
    }
}

extension ReviewViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
