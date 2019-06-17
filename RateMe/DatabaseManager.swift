//
//  DatabaseManager.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/16/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import Foundation
import Firebase

class DatabaseManager {
    
    static var shared = DatabaseManager()
    var db: Firestore!
    
    private init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func createUser(user: User, onCompletion: @escaping (Bool?, Error?) -> Void) {
        let documentName = user.getName()
        let data = user.generateData()
        db.collection("users").document(documentName).setData(data) { err in
            if let err = err {
                print("Error en la escritura")
                onCompletion(nil, err)
            } else {
                print("Escritura exitosa")
                onCompletion(true, nil)
            }            
        }
    }
    
}
