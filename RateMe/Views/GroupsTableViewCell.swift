//
//  GroupsTableViewCell.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/19/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var participantsQuantityLabel: UILabel!
    @IBOutlet weak var reviewTypesQuantityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setGroupData(group: Group) {
        if let name = group.name as String?, let participants = group.participants as [User]?, let reviewTypes = group.reviewTypes as [ReviewType]? {
            nameLabel.text = name
            participantsQuantityLabel.text = "Participants: " + String(participants.count)
            reviewTypesQuantityLabel.text = "Review types: " + String(reviewTypes.count)
        }
        
    }

}
