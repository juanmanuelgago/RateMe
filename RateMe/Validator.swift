//
//  Validator.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 7/2/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import Foundation

class Validator {
    
    static func isValidEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    static func isValidAge(age: String) -> Bool {
        if age.isInt {
            let ageInteger = Int(age)!
            return ageInteger >= 18 && ageInteger <= 100
        } else {
            return false
        }
    }
    
    static func isValidName(name: String) -> Bool {
        let noSpaceName = name.replacingOccurrences(of: " ", with: "")
        for chr in noSpaceName {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }

}

extension String {
    //Checks if string can be transformed to valid integer.
    var isInt: Bool {
        return Int(self) != nil
    }
}
