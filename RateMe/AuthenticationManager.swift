//
//  AuthenticationManager.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/15/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationManager {
    
    static var shared = AuthenticationManager()
    var loggedUser: User?
    
    private init() { }

    func createUser(user: User, password: String, onCompletion: @escaping (Bool?, Error?) -> Void) {
        if let email = user.email as String? {
            Auth.auth().createUser(withEmail: email, password: password) { (signUpResponse, error) in
                guard let user = signUpResponse?.user else {
                    
                    return onCompletion(nil, error)
                }
                onCompletion(true, nil)
            }
        }
    }
    
    func login(email: String, password: String, onCompletion: @escaping (Any?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (loginResponse, error) in
            
            guard let loggedUser = loginResponse?.user else {
                return onCompletion(nil, error)
            }
            onCompletion(loggedUser, error)
        }
    }
    
    func logout(onCompletion: @escaping (Bool?, Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            onCompletion(true, nil)
        } catch let errorLogout {
            onCompletion(nil, errorLogout)
        }
    }
    
    func isLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
}
