//
//  RegisterViewController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/12/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var profilePhotoImage: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatedPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyCornerRadius()
        applyRoundedImage()
    }
    
    func applyRoundedImage() {
        profilePhotoImage.layer.masksToBounds = false
        profilePhotoImage.layer.cornerRadius = profilePhotoImage.frame.height / 2
        profilePhotoImage.clipsToBounds = true
    }
    
    func applyCornerRadius() {
        registerButton.layer.cornerRadius = 8
        emailTextField.layer.cornerRadius = 8
        passwordTextField.layer.cornerRadius = 8
        fullNameTextField.layer.cornerRadius = 8
        ageTextField.layer.cornerRadius = 8
        repeatedPasswordTextField.layer.cornerRadius = 8
        passwordTextField.layer.cornerRadius = 8
    }
    
    @IBAction func didPressRegister(_ sender: Any) {
    }

}
