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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users: [User] = []
    var filteredUsers: [User] = []
    
    var groups: [Group]?
    
    // Filter values for the array of users.
    var genderFilter: String?
    var ageFromFilter: Int?
    var ageToFilter: Int?
    
    // For the reviee process.
    var selectedUser: User?
    var selectedReviewType: ReviewType?
    
    // Filter for the search bar.
    var searching = false
    // Filter for the custom filters
    var filtersFlag = false
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // For the filters view controller.
        if segue.identifier == "FilterSegue" {
            let filtersViewController = segue.destination as! FiltersViewController
            if let genderFilter = genderFilter as String? {
                filtersViewController.gender = genderFilter
            }
            if let ageFromFilter = ageFromFilter as Int? {
                filtersViewController.fromAge = ageFromFilter
            }
            if let ageToFilter = ageToFilter as Int? {
                filtersViewController.toAge = ageToFilter
            }
            filtersViewController.filterDelegate = self
        }
        if segue.identifier == "ReviewSegue" {
            let reviewViewController = segue.destination as! ReviewViewController
            if let selectedUser = selectedUser as User?, let selectedReviewType = selectedReviewType as ReviewType?, let loggedUser = AuthenticationManager.shared.loggedUser as User? {
                reviewViewController.newReview = Review(userTo: selectedUser, reviewType: selectedReviewType, isAnonymous: true)
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
        searchBar.text = ""
        searching = false
        performSegue(withIdentifier: "FilterSegue", sender: self)
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filtersFlag || searching {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UserCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! UserCollectionViewCell
        var user: User
        if filtersFlag || searching {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
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
        // GET REVIEWS FOR THE GROUPS OF THE USER
        // SHOW ACTION SHEET WITH OPTIONS
        if let cellLocation = userCollectionView.indexPath(for: cell) as IndexPath? {
            var userOfCell: User
            if filtersFlag || searching {
                userOfCell = filteredUsers[cellLocation.row]
            } else {
                userOfCell = users[cellLocation.row]
            }
            let groupsOfUser = checkSelectedUserGroup(userSelected: userOfCell)
            let reviewTypesActionSheet = UIAlertController(title: nil, message: "Choose review", preferredStyle: .actionSheet)
            for groupOfUser in groupsOfUser {
                if let reviewTypes = groupOfUser.reviewTypes as [ReviewType]? {
                    for reviewType in reviewTypes {
                        if let name = reviewType.name as String? {
                            let review = UIAlertAction(title: name, style: .default) { (_) in
                                let index = reviewTypes.firstIndex(where: { (type: ReviewType) -> Bool in
                                    type.name == name
                                })
                                if let index = index as Int? {
                                    self.selectedReviewType = reviewTypes[index]
                                    self.selectedUser = userOfCell
                                    self.performSegue(withIdentifier: "ReviewSegue", sender: self)
                                }
                            }
                            reviewTypesActionSheet.addAction(review)
                        }
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            reviewTypesActionSheet.addAction(cancelAction)
            self.present(reviewTypesActionSheet, animated: true, completion: nil)
        }
    }
    
    func checkSelectedUserGroup(userSelected: User) -> [Group] {
        var groupsOfUser: [Group] = []
        if let groups = groups as [Group]? {
            for group in groups {
                if let participants = group.participants as [User]? {
                    for participant in participants {
                        if participant.email == userSelected.email {
                            groupsOfUser.append(group)
                            break
                        }
                    }
                }
            }
        }
        return groupsOfUser
    }
}

extension DashboardViewController: UISearchBarDelegate, UIScrollViewDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            if filtersFlag {
                applyFilters()
                filteredUsers = filteredUsers.filter({ (user: User) -> Bool in
                    if let name = user.fullName?.lowercased() as String? {
                        return name.contains(searchText.lowercased())
                    } else {
                        return false
                    }
                })
                searching = true
            } else {
                filteredUsers = users.filter({ (user: User) -> Bool in
                    if let name = user.fullName?.lowercased() as String? {
                        return name.contains(searchText.lowercased())
                    } else {
                        return false
                    }
                })
                searching = true
            }
        } else {
            searching = false
            applyFilters()
        }
        userCollectionView.reloadData()
    }
    
    // Dismisses the keyboard if the search button is pressed.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // Dismiss the keyboard when the view is scrolling.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

extension DashboardViewController: FilterDelegate {
    
    func setFilters(gender: String?, fromAge: Int?, toAge: Int?) {
        var isApplyingFilters = false
        genderFilter = gender
        ageFromFilter = fromAge
        ageToFilter = toAge
        if let _ = gender as String? {
            print("gender esta como filtro!")
            isApplyingFilters = true
        }
        if let _ = fromAge as Int? {
            print("age from está como filtro!")
            isApplyingFilters = true
        }
        if let _ = toAge as Int? {
            print("age to está como filtro!")
            isApplyingFilters = true
        }
        filtersFlag = isApplyingFilters
        print("flag? \(filtersFlag)" )
        print("---")
        applyFilters()
    }
    
    func applyFilters() {
        filteredUsers = []
        //Filtering for age
        filteredUsers = users.filter { (user: User) -> Bool in
            if let higherAge = self.ageToFilter as Int?, let lowerAge = self.ageFromFilter as Int? {
                if let comparisonAge = user.age as Int? {
                    if comparisonAge >= lowerAge && comparisonAge <= higherAge {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return true
                }
            } else {
                if self.ageFromFilter == nil && self.ageToFilter == nil {
                    return true
                } else {
                    if self.ageFromFilter != nil {
                        if let comparisonAge = user.age as Int? {
                            if comparisonAge >= self.ageFromFilter! {
                                return true
                            } else {
                                return false
                            }
                        } else {
                            return true
                        }
                    } else {
                        if let comparisonAge = user.age as Int? {
                            if comparisonAge <= self.ageToFilter! {
                                return true
                            } else {
                                return false
                            }
                        } else {
                            return true
                        }
                    }
                }
            }
        }
        //Filtering for gender
        filteredUsers = filteredUsers.filter { (user: User) -> Bool in
            if let gender = self.genderFilter as String? {
                if let comparisonGender = user.gender as String? {
                    if comparisonGender == gender {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                return true
            }
        }
        userCollectionView.reloadData()
    }
    
}

