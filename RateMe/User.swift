//
//  User.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/15/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import Foundation

class User {
    
    let fullName: String?
    let gender: String?
    let age: Int?
    let email: String?
    var photoUrl: String?
    
    init(fullName: String?, gender: String?, age: Int?, email: String?, photoUrl: String?) {
        self.fullName = fullName
        self.gender = gender
        self.age = age
        self.email = email
        self.photoUrl = photoUrl
    }
    
    init(userData: [String: Any]) {
        self.fullName = userData["fullName"] as? String
        self.gender = userData["gender"] as? String
        self.age = userData["age"] as? Int
        self.email = userData["email"] as? String
        self.photoUrl = userData["photoUrl"] as? String
     }
    
    func getName() -> String {
        if let fullName = self.fullName as String? {
            let name = fullName.replacingOccurrences(of: " ", with: "")
            return name.lowercased()
        } else {
            return ""
        }
    }
    
    func generateData() -> [String: Any] {
        var simulatedJSON: [String: Any] = [:]
        simulatedJSON["fullName"] = self.fullName!
        simulatedJSON["age"] = self.age!
        simulatedJSON["email"] = self.email!
        simulatedJSON["gender"] = self.gender!
        if let photoUrl = self.photoUrl as String? {
            simulatedJSON["photoUrl"] = photoUrl
        }
        return simulatedJSON
    }
    
}
