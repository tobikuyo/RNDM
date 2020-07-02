//
//  Thought.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 27/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class Thought {
    private(set) var username: String
    private(set) var thoughtText: String
    private(set) var numLikes: Int
    private(set) var numComments: Int
    private(set) var timestamp: Date
    private(set) var documentID: String
    private(set) var userID: String

    init(username: String, thoughtText: String, numLikes: Int, numComments: Int, timestamp: Date, documentID: String, userID: String) {
        self.username = username
        self.thoughtText = thoughtText
        self.numLikes = numLikes
        self.numComments = numComments
        self.timestamp = timestamp
        self.documentID = documentID
        self.userID = userID
    }

    class func parse(_ snapshot: QuerySnapshot?) -> [Thought] {
        var thoughts: [Thought] = []

        guard let documents = snapshot?.documents else { return thoughts }

        for document in documents {
            let data = document.data()
            let username = Auth.auth().currentUser?.displayName ?? "Anonymous"
            let timestamp = data[DB.timestamp] as? Timestamp ?? Timestamp()
            let thoughtText = data[DB.thoughtText] as? String ?? ""
            let numLikes = data[DB.numLikes] as? Int ?? 0
            let numComments = data[DB.numComments] as? Int ?? 0
            let documentID = document.documentID
            let userID = data[DB.userID] as? String ?? ""

            let thought = Thought(username: username,
                                  thoughtText: thoughtText,
                                  numLikes: numLikes,
                                  numComments: numComments,
                                  timestamp: timestamp.dateValue(),
                                  documentID: documentID,
                                  userID: userID)
            thoughts.append(thought)
        }
        
        return thoughts
    }
}
