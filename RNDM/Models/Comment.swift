//
//  Comment.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 29/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

class Comment {
    private(set) var username: String
    private(set) var timestamp: Date
    private(set) var commentText: String

    init(username: String, timestamp: Date, commentText: String) {
        self.username = username
        self.timestamp = timestamp
        self.commentText = commentText
    }
}
