//
//  LoginViewController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/12/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyCornerRadius()
    }
    
    func applyCornerRadius() {
        loginButton.layer.cornerRadius = 8
        emailTextField.layer.cornerRadius = 8
        passwordTextField.layer.cornerRadius = 8
    }
    
    @IBAction func didPressLogin(_ sender: Any) {
    }
    
    @IBAction func didPressSignUp(_ sender: Any) {
        performSegue(withIdentifier: "RegisterSegue", sender: self)
    }

}

class CustomInputTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
