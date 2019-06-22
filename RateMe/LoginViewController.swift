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
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyCornerRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        if AuthenticationManager.shared.isLoggedIn() {
//            print("Hay un usuario conectado.")
//            performSegue(withIdentifier: "MainSegue1", sender: self)
//        }
        AuthenticationManager.shared.logout { (result, error) in
            
        }
    }
    
    func applyCornerRadius() {
        loginButton.layer.cornerRadius = 8
        emailTextField.layer.cornerRadius = 8
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
    
    @IBAction func didPressLogin(_ sender: Any) {
        if let email = emailTextField.text as String?, let password = passwordTextField.text as String? {
            startActivityIndicator()
            AuthenticationManager.shared.login(email: email, password: password) { (loginResponse, error) in
                if let _ = error as Error? {
                    self.showAlert(title: "Login error", message: "Invalid credentials.")
                    self.stopActivityIndicator()
                } else {
                    self.showAlert(title: "Successful Login", message: "Valid credentials!!!")
                    self.stopActivityIndicator()
                }
            }
        } else {
            showAlert(title: "Login error", message: "Please, fill all the requested fields to proceed.")
        }
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
