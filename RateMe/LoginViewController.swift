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
            print("esta logueado")
            DatabaseManager.shared.getUser { (loggedUser, error) in
                if let _ = error {
                    AuthenticationManager.shared.loggedUser = nil
                } else {
                    if let loggedUser = loggedUser as User? {
                        print("logged user es \(loggedUser.email!)" )
                        AuthenticationManager.shared.loggedUser = loggedUser
                        self.performSegue(withIdentifier: "MainSegue1", sender: self)
                    }
                }
            }
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
    
    @IBAction func didPressLogin(_ sender: Any) {
        guard let email = emailTextField.text else {
            showAlert(title: "Login error", message: "Please, fill the requested fields to proceed.")
            return
        }
        guard let password = passwordTextField.text else {
            showAlert(title: "Login error", message: "Please, fill the requested fields to proceed.")
            return
        }
        
        if email != "" && password != "" {
            if Validator.isValidEmail(email: email) {
                startActivityIndicator()
                AuthenticationManager.shared.login(email: email, password: password) { (loginResponse, error) in
                    if let _ = error as Error? {
                        self.stopActivityIndicator()
                        self.showAlert(title: "Login error", message: "Invalid credentials.")
                        self.passwordTextField.text = ""
                    } else {
                        DatabaseManager.shared.getUser(onCompletion: { (user, error) in
                            if let _ = error {
                                self.stopActivityIndicator()
                                self.showAlert(title: "Login error", message: "There's been an error processing the information. Please, try again later.")
                                self.passwordTextField.text = ""
                                
                            } else {
                                if let user = user as User? {
                                    self.stopActivityIndicator()
                                    AuthenticationManager.shared.loggedUser = user
                                    self.performSegue(withIdentifier: "MainSegue1", sender: self)
                                }
                            }
                        })
                    }
                }
            } else {
                showAlert(title: "Login error", message: "Your email is invalid. Change it.")
                self.passwordTextField.text = ""
            }
        } else {
            showAlert(title: "Login error", message: "Please, fill the requested fields to proceed.")
            self.passwordTextField.text = ""
        }
    }
    
    @IBAction func didPressSignUp(_ sender: Any) {
        performSegue(withIdentifier: "RegisterSegue", sender: self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

