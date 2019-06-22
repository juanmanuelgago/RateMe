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
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getGroups()
    }
    
    func getGroups() {
        startActivityIndicator()
        DatabaseManager.shared.getGroups { (groupList, error) in
            if let error = error {
                print("Error al traer los grupos. Intente luego más tarde.")
                print(error)
                print("")
                self.stopActivityIndicator()
            } else {
                if let groupList = groupList as [Group]? {
                    print("Obtuve los grupos!")
                    self.groups = groupList
                    self.groupsTableView.reloadData()
                    self.stopActivityIndicator()
                }
            }
        }
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
    }

}

extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "GroupCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! GroupsTableViewCell
        cell.setGroupData(group: groups[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: 110)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
