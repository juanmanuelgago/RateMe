//
//  GroupsViewController.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/16/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController {

    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    
    var groups: [Group] = []
    var selectedGroups: [Group] = []
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyCornerRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getGroups()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainTabViewController = segue.destination as! MainTabBarController
        let dashboardNavController = mainTabViewController.viewControllers![0] as! MainNavigationController
        let dashboardViewController = dashboardNavController.topViewController as! DashboardViewController
        dashboardViewController.groups = self.selectedGroups
    }
    
    func getGroups() {
        DatabaseManager.shared.getGroups { (groupList, error) in
            if let error = error {
                print("Error al traer los grupos. Intente luego más tarde.")
                print(error)
                print("")
            } else {
                if let groupList = groupList as [Group]? {
                    self.groups = groupList
                    self.groupsTableView.reloadData()
                }
            }
        }
    }
    
    func applyCornerRadius() {
        joinButton.layer.cornerRadius = 8
    }
    
    // Start the activity indicator. This method is called when the requests are being done.
    // The component is inside a new view, initialized here.
    func startActivityIndicator() {
        let newView = UIView(frame: UIScreen.main.bounds)
        newView.tag = 100 // Random tag, for the process of dismissing the view.
        newView.backgroundColor = .white
        self.view.addSubview(newView)
        newView.addSubview(activityIndicator)
        activityIndicator.center = newView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        if let viewTag = self.view.viewWithTag(100) { // If the tag is 100, then it's the correct view to remove.
            viewTag.removeFromSuperview()
        }
    }
    
    @IBAction func didPressJoin(_ sender: Any) {
        startActivityIndicator()
        if selectedGroups.count == 0 {
            showAlert(title: "Groups error", message: "At least, you have to be joined to one group.")
            stopActivityIndicator()
        } else {
            var counting = 1
            for selectedGroup in selectedGroups {
                DatabaseManager.shared.addUserToGroup(group: selectedGroup) { (addingResult, error) in
                    if let error = error {
                        print(error)
                        self.showAlert(title: "Unexpected error", message: "There's a problem in the process.")
                        self.stopActivityIndicator()
                    } else {
                        if let result = addingResult as Bool? {
                            if result {
                                if counting == self.selectedGroups.count {
                                    self.performSegue(withIdentifier: "MainSegue2", sender: self)
                                } else {
                                    counting += 1
                                }
                            } else {
                                print("No se añadió el grupo \(selectedGroup.id)")
                                self.showAlert(title: "Unexpected error", message: "There's a problem in the process.")
                                self.stopActivityIndicator()
                            }
                        }
                    }
                }
            }
        }
    }

}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "GroupCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! GroupsTableViewCell
        cell.tintColor = UIColor(red: 23.0/255, green: 178.0/255, blue: 85.0/255, alpha: 1.0)
        cell.setGroupData(group: groups[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 110)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
           tableView.cellForRow(at: indexPath)?.accessoryType = .none
           removeFromSelectedGroups(group: groups[indexPath.row])
        } else {
           tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
           let groupSelected = groups[indexPath.row]
           selectedGroups.append(groupSelected)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func removeFromSelectedGroups(group: Group) {
        for i in 0..<selectedGroups.count {
            if selectedGroups[i].id == group.id {
                selectedGroups.remove(at: i)
                break
            }
        }
    }
}

