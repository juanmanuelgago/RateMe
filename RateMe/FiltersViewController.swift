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

    override func viewDidLoad() {
        super.viewDidLoad()
        applyCornerRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showActualFilters()
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
            if fromAge != "" { fromAgeVar = Int(fromAge) }
            if toAge != "" { toAgeVar = Int(toAge) }
            filterDelegate?.setFilters(gender: genderVar, fromAge: fromAgeVar, toAge: toAgeVar)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
