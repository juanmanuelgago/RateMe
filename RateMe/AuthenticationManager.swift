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
    static var loggedUser: User?
    
    private init() { }

    func createUser(user: User, password: String, onCompletion: @escaping (Bool?, Error?) -> Void) {
        if let email = user.email as String? {
            Auth.auth().createUser(withEmail: email, password: password) { (signUpResponse, error) in
                if signUpResponse != nil {
                    print("Exitoso en Respuesta de SignUp")
                    print(signUpResponse)
                }
                if error != nil {
                    print("Error en Respuesta de SignUp")
                    print(error)
                }
                
                
                guard let user = signUpResponse?.user else {
                    
                    return onCompletion(nil, error)
                }
                onCompletion(true, nil)
            }
        }
    }
    
    func login(email: String, password: String, onCompletion: @escaping (Any?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (loginResponse, error) in
            if loginResponse != nil {
                print("Exitoso en Respuesta de Login")
                print(loginResponse)
            }
            if error != nil {
                print("Error en Respuesta de Login")
                print(error)
            }
            
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
            print(Auth.auth().currentUser?.email!)
            return true
        } else {
            return false
        }
    }
    
}
