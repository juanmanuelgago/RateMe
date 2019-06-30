//
//  ReviewType.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/19/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import Foundation

class ReviewType {
    
    var name: String?
    var description: String?
    var questions: [String]?
    
    init(reviewTypeData: [String: Any] ) {
        self.name = reviewTypeData["name"] as? String
        self.description = reviewTypeData["description"] as? String
        self.questions = reviewTypeData["questions"] as? [String]
    }
    
    func generateData() -> [String: Any] {
        var simulatedJSON : [String: Any] = [:]
        simulatedJSON["name"] = self.name!
        simulatedJSON["description"] = self.description!
        simulatedJSON["questions"] = self.questions!
        return simulatedJSON
    }
    
    func getName() -> String {
        if let name = self.name as String? {
            let forDocName = name.replacingOccurrences(of: " ", with: "")
            return forDocName.lowercased()
        } else {
            return ""
        }
    }
}
