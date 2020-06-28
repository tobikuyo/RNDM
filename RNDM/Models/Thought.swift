//
//  Thought.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 27/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

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
}
