//
//  FiltersViewController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/23/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit

protocol FilterDelegate {
    func setFilters(gender: String?, fromAge: Int?, toAge: Int?)
}

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var genderLabel: UITextField!
    @IBOutlet weak var fromAgeLabel: UITextField!
    @IBOutlet weak var toAgeLabel: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var filterDelegate: FilterDelegate?
    
    var gender: String?
    var fromAge: Int?
    var toAge: Int?
    
    var picker = UIPickerView()
    let genderOptions = ["", "Female", "Male"]

    override func viewDidLoad() {
        super.viewDidLoad()
        applyCornerRadius()
        assignPickerToTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showActualFilters()
    }
    
    func assignPickerToTextField() {
        picker.delegate = self
        picker.dataSource = self
        genderLabel.inputView = picker
        if let gender = gender as String? {
            if let row = genderOptions.index(of: gender) {
                picker.selectRow(row, inComponent: 0, animated: false)
            }
        }
    }
    
    func applyCornerRadius() {
        applyButton.layer.cornerRadius = 8
        genderLabel.layer.cornerRadius = 8
        fromAgeLabel.layer.cornerRadius = 8
        toAgeLabel.layer.cornerRadius = 8
    }
    
    func showActualFilters() {
        if let gender = gender as String? {
            genderLabel.text = gender
        }
        if let fromAge = fromAge as Int? {
            fromAgeLabel.text = String(fromAge)
        }
        if let toAge = toAge as Int? {   
            toAgeLabel.text = String(toAge)
        }
    }
    
    @IBAction func didPressApply(_ sender: Any) {
        if let gender = genderLabel.text as String?, let fromAge = fromAgeLabel.text as String?, let toAge = toAgeLabel.text as String? {
            var genderVar: String?
            var fromAgeVar: Int?
            var toAgeVar: Int?
            if gender != "" { genderVar = gender }
            if fromAge != "" {
                if Validator.isValidAge(age: fromAge) {
                    fromAgeVar = Int(fromAge)
                } else {
                    showAlert(title: "Filters error", message: "First age value is invalid. Must be between 18 and 100.")
                    return
                }
            }
            if toAge != "" {
                if Validator.isValidAge(age: toAge) {
                    toAgeVar = Int(toAge)
                } else {
                    showAlert(title: "Filters error", message: "Second age value is invalid. Must be between 18 and 100.")
                    return
                }
            }
            filterDelegate?.setFilters(gender: genderVar, fromAge: fromAgeVar, toAge: toAgeVar)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FiltersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        toAgeLabel.resignFirstResponder()
        fromAgeLabel.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension FiltersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderLabel.text = genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
}


