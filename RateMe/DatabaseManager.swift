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
    
    func getUser(onCompletion: @escaping (User?, Error?) -> Void) {
        if let user = Auth.auth().currentUser, let email = user.email as String? {
            db.collection("users").whereField("email", isEqualTo: email)
                .getDocuments { (userDocuments, err) in
                    if let err = err {
                        onCompletion(nil, err)
                    } else {
                        if userDocuments!.count == 1 {
                            let userData = userDocuments!.documents[0].data()
                            let loggedUser = User(userData: userData)
                            onCompletion(loggedUser, nil)
                        }
                    }
            }
        }
    }
    
    func addUserToGroup(group: Group, onCompletion: @escaping (Bool?, Error?) -> Void) {
        if let loggedUser = AuthenticationManager.shared.loggedUser as User? {
            let documentName = loggedUser.getName()
            let data = loggedUser.generateData()
            let participantsRef = db.collection("groups").document(group.id).collection("participants")
            participantsRef.document(documentName).setData(data) { err in
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
    
    func getGroups(onCompletion: @escaping ([Group]?, Error?) -> Void) {
        let groupsRef = db.collection("groups")
        var groups : [Group] = []
        groupsRef.getDocuments { (groupsDocs, err) in
            if let err = err as Error? {
                onCompletion(nil, err)
            } else {
                var finished = 1
                for document in groupsDocs!.documents {
                    let reviewTypesRef = groupsRef.document(document.documentID).collection("reviewTypes")
                    let participantsRef = groupsRef.document(document.documentID).collection("participants")
                    
                    var reviewTypesArray : [ReviewType] = []
                    var usersArray : [User] = []
                    
                    self.getReviewTypesFromGroup(reviewTypesReference: reviewTypesRef, onCompletionReviewTypes: { (reviewTypes, errorReviews) in
                        if let error = errorReviews {
                            onCompletion(nil, error)
                        } else {
                            reviewTypesArray = reviewTypes!
                            self.getUsersFromGroup(usersReference: participantsRef, onCompletionUsers: { (users, errorUsers) in
                                if let error = errorUsers {
                                    onCompletion(nil, error)
                                } else {
                                    usersArray = users!
                                    let group = Group(id: document.documentID, name: document.data()["name"] as? String, participants: usersArray, reviewTypes: reviewTypesArray)
                                    groups.append(group)
                                    if groupsDocs!.documents.count == finished {
                                        onCompletion(groups, nil)
                                    } else {
                                        finished += 1
                                    }
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
    private func getReviewTypesFromGroup(reviewTypesReference: CollectionReference, onCompletionReviewTypes: @escaping ([ReviewType]?, Error?) -> Void)  {
        var reviewTypes: [ReviewType] = []
        reviewTypesReference.getDocuments(completion: { (reviewTypesDocs, err) in
            if let err = err as Error? {
                onCompletionReviewTypes(nil, err)
            } else {
                for reviewTypeDoc in reviewTypesDocs!.documents {
                    let reviewType = ReviewType(reviewTypeData: reviewTypeDoc.data())
                    reviewTypes.append(reviewType)
                }
                onCompletionReviewTypes(reviewTypes, nil)
            }
        })
    }
    
    private func getUsersFromGroup(usersReference: CollectionReference, onCompletionUsers: @escaping ([User]?, Error?) -> Void) {
        var users: [User] = []
        usersReference.getDocuments(completion: { (userDocs, err) in
            if let err = err as Error? {
                onCompletionUsers(nil, err)
            } else {
                for userDoc in userDocs!.documents {
                    let user = User(userData: userDoc.data())
                    users.append(user)
                }
                onCompletionUsers(users, nil)
            }
        })
    }
    
}
