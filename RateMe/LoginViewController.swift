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
        if AuthenticationManager.shared.isLoggedIn() {
            DatabaseManager.shared.getUser { (loggedUser, error) in
                if let _ = error {
                    AuthenticationManager.shared.loggedUser = nil
                } else {
                    if let loggedUser = loggedUser as User? {
                        AuthenticationManager.shared.loggedUser = loggedUser
                        self.performSegue(withIdentifier: "MainSegue1", sender: self)
                    }
                }
            }
        }
//        AuthenticationManager.shared.logout { (bo, err)  }
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
    
    @IBAction func didPressLogin(_ sender: Any) {
        if let email = emailTextField.text as String?, let password = passwordTextField.text as String? {
            startActivityIndicator()
            AuthenticationManager.shared.login(email: email, password: password) { (loginResponse, error) in
                if let _ = error as Error? {
                    self.showAlert(title: "Login error", message: "Invalid credentials.")
                    self.stopActivityIndicator()
                } else {
                    DatabaseManager.shared.getUser(onCompletion: { (user, error) in
                        if let error = error {
                            self.stopActivityIndicator()
                            self.showAlert(title: "Login error", message: "There's been an error processing the information. Please, try again later.")
                        } else {
                            if let user = user as User? {
                                AuthenticationManager.shared.loggedUser = user
                                self.performSegue(withIdentifier: "MainSegue1", sender: self)
                                self.stopActivityIndicator()
                            }
                        }
                    })
                }
            }
        } else {
            showAlert(title: "Login error", message: "Please, fill the requested fields to proceed.")
        }
    }
    
    @IBAction func didPressSignUp(_ sender: Any) {
        performSegue(withIdentifier: "RegisterSegue", sender: self)
    }

}
