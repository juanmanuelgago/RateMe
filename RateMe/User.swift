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
    
}
