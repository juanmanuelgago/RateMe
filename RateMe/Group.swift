//
//  Group.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/19/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import Foundation

class Group {
    
    let id: String
    let name: String?
    let participants: [User]?
    let reviewTypes: [ReviewType]?
    
    init(id: String, name: String?, participants: [User]?, reviewTypes: [ReviewType]?) {
        self.id = id
        self.name = name
        self.participants = participants
        self.reviewTypes = reviewTypes
    }

}
