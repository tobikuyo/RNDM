//
//  ThoughtController.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 28/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import Firebase

class DataService {

    var thoughts: [Thought] = []

    func parseData(_ snapshot: QuerySnapshot?) -> [Thought] {

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
