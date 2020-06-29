//
//  Comment.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 29/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    private(set) var username: String
    private(set) var timestamp: Date
    private(set) var commentText: String

    init(username: String, timestamp: Date, commentText: String) {
        self.username = username
        self.timestamp = timestamp
        self.commentText = commentText
    }

    class func parse(_ snapshot: QuerySnapshot?) -> [Comment] {
        var comments: [Comment] = []

        guard let documents = snapshot?.documents else { return comments }

        for document in documents {
            let data = document.data()
            let username = data[DB.username] as? String ?? "Anonymous"
            let timestamp = data[DB.timestamp] as? Timestamp ?? Timestamp()
            let commentText = data[DB.commentText] as? String ?? ""

            let comment = Comment(username: username, timestamp: timestamp.dateValue(), commentText: commentText)
            comments.append(comment)
        }

        return comments
    }
}
