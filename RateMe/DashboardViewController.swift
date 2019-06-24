//
//  DashboardViewController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/16/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var filtersButton: UIBarButtonItem!
    
    var users: [User] = []
    var filteredUsers: [User] = []
    
    var groups: [Group]?
    
    // Filter values for the array of users.
    var genderFilter = "both"
    var ageFromFilter = 15
    var ageToFilter = 80
    var groupFilter = "all"
    
    // Filter for the search bar.
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.users = []
        if let groups = groups as [Group]? {
            fillUserData(groups: groups)
            userCollectionView.reloadData()
        } else {
            DatabaseManager.shared.getGroupsOfUser { (groupsOfUser, error) in
                print("Entro en la respuesta del getGroups")
                if let _ = error {
                    self.showAlert(title: "Unexpected error", message: "Try again later.")
                } else {
                    if let groupsOfUser = groupsOfUser as [Group]? {
                        self.groups = groupsOfUser
                        self.fillUserData(groups: groupsOfUser)
                        self.userCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func fillUserData(groups: [Group]) {
        for group in groups {
            if let participants = group.participants as [User]? {
                for participant in participants {
                    if participant.email! != AuthenticationManager.shared.loggedUser?.email, checkIfExists(userToCheck: participant) {
                        users.append(participant)
                    }
                }
            }
        }
    }
    
    func checkIfExists(userToCheck: User) -> Bool {
        for user in users {
            if userToCheck.email == user.email {
                return false
            }
        }
        return true
    }
    
    @IBAction func didPressFilters(_ sender: Any) {
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UserCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! UserCollectionViewCell
        let user = users[indexPath.row]
        cell.userReviewDelegate = self
        cell.setData(user: user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: 200) // Size of the cell.
    }
    
}

extension DashboardViewController: UserReviewDelegate {
    func didRequestToReview(cell: UICollectionViewCell) {
        
    }
    
    
}

