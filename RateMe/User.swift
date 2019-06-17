//
//  User.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/15/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import Foundation

class User {
    
    let fullName: String
    let gender: String
    let age: Int
    let email: String
    
    init(fullName: String, gender: String, age: Int, email: String) {
        self.fullName = fullName
        self.gender = gender
        self.age = age
        self.email = email
    }
    
    func getName() -> String {
        let name = self.fullName.replacingOccurrences(of: " ", with: "")
        return name.lowercased()
    }
    
    func generateData() -> [String: Any] {
        var simulatedJSON: [String: Any] = [:]
        simulatedJSON["fullName"] = self.fullName
        simulatedJSON["age"] = self.age
        simulatedJSON["email"] = self.email
        simulatedJSON["gender"] = self.gender
        return simulatedJSON
    }
    
}
