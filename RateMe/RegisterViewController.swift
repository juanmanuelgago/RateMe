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
    
    var activityIndicator = UIActivityIndicatorView()
    
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
    
    func startActivityIndicator() {
        let newView = UIView(frame: UIScreen.main.bounds)
        newView.tag = 101 // Random tag, for the process of dismissing the view.
        newView.backgroundColor = .white
        newView.alpha = 0.5
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
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressRegister(_ sender: Any) {
        // TODO: Validation of textfields values.
        if let name = fullNameTextField.text as String?, let age = ageTextField.text as String?, let email = emailTextField.text as String?, let password = passwordTextField.text as String?, let repeatedPassword = passwordTextField.text as String?, let gender = genderTextField.text as String? {
            if (password == repeatedPassword) {
                startActivityIndicator()
                let newUser = User(fullName: name, gender: gender, age: Int(age)!, email: email)
                AuthenticationManager.shared.createUser(user: newUser, password: password) { (response, error) in
                    if let _ = error as Error? {
                        self.showAlert(title: "Register error", message: "Unable to create user. Please, try again later.")
                        self.stopActivityIndicator()
                    } else {
                        DatabaseManager.shared.createUser(user: newUser) { (response, error) in
                            self.performSegue(withIdentifier: "GroupSegue", sender: self)
                        }
                    }
                }
            } else {
                showAlert(title: "Register error", message: "Passwords don't match. Try again.")
            }
        } else {
            showAlert(title: "Register error", message: "Please, fill all the requested fields on the form.")
        }
    }

}
