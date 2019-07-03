//
//  RegisterViewController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/12/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profilePhotoImage: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatedPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var activityIndicator = UIActivityIndicatorView()
    var picker = UIPickerView()
    var imagePicker: UIImagePickerController!
    var imageChanged = false
    let genderOptions = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyCornerRadius()
        applyRoundedImage()
        assignPickerToTextField()
        addImageTap()
    }
    
    func addImageTap() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profilePhotoImage.isUserInteractionEnabled = true
        profilePhotoImage.addGestureRecognizer(imageTap)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    func applyRoundedImage() {
        profilePhotoImage.layer.masksToBounds = true
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
        genderTextField.layer.cornerRadius = 8
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
    
    func assignPickerToTextField() {
        picker.delegate = self
        picker.dataSource = self
        genderTextField.inputView = picker
    }
    
    @objc func openImagePicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressRegister(_ sender: Any) {
        guard let email = emailTextField.text, let age = ageTextField.text, let name = fullNameTextField.text, let password = passwordTextField.text, let repeatedPassword = passwordTextField.text, let gender = genderTextField.text else {
            showAlert(title: "Register error", message: "Please, fill all the requested fields on the form.")
            return
        }
        
        if name != "" && age != "" && email != "" && password != "" && repeatedPassword != "" && gender != "" {
            if (password == repeatedPassword) {
                if Validator.isValidEmail(email: email) {
                    if Validator.isValidAge(age: age) {
                        if Validator.isValidName(name: name) {
                            startActivityIndicator()
                            let newUser = User(fullName: name, gender: gender, age: Int(age)!, email: email, photoUrl: nil)
                            AuthenticationManager.shared.createUser(user: newUser, password: password) { (response, error) in
                                if let _ = error as Error? {
                                    self.showAlert(title: "Register error", message: "Unable to create user. Please, try again later.")
                                    self.stopActivityIndicator()
                                } else {
                                    if self.imageChanged {
                                        DatabaseManager.shared.uploadUserPhoto(image: self.profilePhotoImage.image!, user: newUser, onCompletion: { (photoURL) in
                                            if photoURL != nil {
                                                let photoUrlString = photoURL?.absoluteString
                                                newUser.photoUrl = photoUrlString
                                                DatabaseManager.shared.createUser(user: newUser) { (response, error) in
                                                    self.stopActivityIndicator()
                                                    AuthenticationManager.shared.loggedUser = newUser
                                                    self.performSegue(withIdentifier: "GroupSegue", sender: self)
                                                }
                                            } else {
                                                DatabaseManager.shared.createUser(user: newUser) { (response, error) in
                                                    self.stopActivityIndicator()
                                                    AuthenticationManager.shared.loggedUser = newUser
                                                    self.performSegue(withIdentifier: "GroupSegue", sender: self)
                                                }
                                            }
                                        })
                                    } else {
                                        DatabaseManager.shared.createUser(user: newUser) { (response, error) in
                                            self.stopActivityIndicator()
                                            AuthenticationManager.shared.loggedUser = newUser
                                            self.performSegue(withIdentifier: "GroupSegue", sender: self)
                                        }
                                    }
                                }
                            }
                        } else {
                            showAlert(title: "Register error", message: "Your name is invalid. Only letters from the alphabet.")
                            self.passwordTextField.text = ""
                            self.repeatedPasswordTextField.text = ""
                        }
                    } else {
                        showAlert(title: "Register error", message: "Invalid age. You must be older than 18 and younger than 100.")
                        self.passwordTextField.text = ""
                        self.repeatedPasswordTextField.text = ""
                    }
                } else {
                    showAlert(title: "Register error", message: "Your email is invalid. Change it.")
                    self.passwordTextField.text = ""
                    self.repeatedPasswordTextField.text = ""
                }
                
            } else {
                showAlert(title: "Register error", message: "Passwords don't match. Try again.")
            }
        } else {
            showAlert(title: "Register error", message: "Please, fill all the requested fields on the form.")
            self.passwordTextField.text = ""
            self.repeatedPasswordTextField.text = ""
        }
    }

}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatedPasswordTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        fullNameTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage? {
            self.profilePhotoImage.image = pickedImage
            imageChanged = true
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


