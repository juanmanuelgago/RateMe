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
        if let questionsData = reviewTypeData["questions"] as? [String], var questions = self.questions as [String]? {
            for question in questionsData {
                questions.append(question)
            }
        } else {
            self.questions = []
        }
    }
}
