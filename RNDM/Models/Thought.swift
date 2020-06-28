//
//  Thought.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 27/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import Firebase

class Thought {
    private(set) var username: String
    private(set) var thoughtText: String
    private(set) var numLikes: Int
    private(set) var numComments: Int
    private(set) var timestamp: Date
    private(set) var documentID: String

    init(username: String, thoughtText: String, numLikes: Int, numComments: Int, timestamp: Date, documentID: String) {
        self.username = username
        self.thoughtText = thoughtText
        self.numLikes = numLikes
        self.numComments = numComments
        self.timestamp = timestamp
        self.documentID = documentID
    }

    class func parse(_ snapshot: QuerySnapshot?) -> [Thought] {
        var thoughts: [Thought] = []

        guard let documents = snapshot?.documents else { return thoughts }

        for document in documents {
            let data = document.data()
            let username = data[DB.username] as? String ?? "Anonymous"
            let timestamp = data[DB.timestamp] as? Timestamp ?? Timestamp()
            let thoughtText = data[DB.thoughtText] as? String ?? ""
            let numLikes = data[DB.numLikes] as? Int ?? 0
            let numComments = data[DB.numComments] as? Int ?? 0
            let documentID = document.documentID

            let thought = Thought(username: username,
                                  thoughtText: thoughtText,
                                  numLikes: numLikes,
                                  numComments: numComments,
                                  timestamp: timestamp.dateValue(),
                                  documentID: documentID)
            thoughts.append(thought)
        }
        
        return thoughts
    }
}
