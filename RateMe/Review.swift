//
//  Review.swift
//  RateMe
//
//  Created by Juan Manuel Gago on 6/29/19.
//  Copyright © 2019 Juan Manuel Gago. All rights reserved.
//

import Foundation

class Review {
    
    let userTo: User
    let userFrom: User?
    let reviewType: ReviewType
    var isAnonymous: Bool
    var comments: String
    var scores: [Double]
    
    init(userTo: User, reviewType: ReviewType, isAnonymous: Bool) {
        self.userTo = userTo
        if let userFrom = AuthenticationManager.shared.loggedUser as User? {
                self.userFrom = userFrom
        } else {
            self.userFrom = nil
        }
        self.reviewType = reviewType
        self.isAnonymous = isAnonymous
        self.scores = [5.0, 5.0, 5.0, 5.0, 5.0]
        self.comments = ""
    }
    
    func assignScore(value: Double, index: Int) {
        scores[index] = value
    }
    
    func assignIsAnonymous(value: Bool) {
        isAnonymous = value
    }
    
    func getAverageScore() -> Double {
        var counter = 0.0
        for score in scores {
            counter += score
        }
        return counter / Double(scores.count)
    }
    
    func generateData() -> [String: Any] {
        var simulatedJSON: [String: Any] = [:]
        simulatedJSON["scores"] = self.scores
        simulatedJSON["comments"] = self.comments
        simulatedJSON["isAnonymous"] = self.isAnonymous
        simulatedJSON["fromUser"] = self.userFrom?.getName()
        simulatedJSON["toUser"] = self.userTo.getName()
        simulatedJSON["reviewType"] = self.reviewType.getName()
        return simulatedJSON
    }
    
}
