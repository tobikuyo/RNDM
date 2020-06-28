//
//  ThoughtTableViewCell.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 28/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class ThoughtTableViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var thoughtTextLabel: UILabel!
    @IBOutlet var likesImage: UIImageView!
    @IBOutlet var likesCountLabel: UILabel!

    func configureCell(thought: Thought) {
        usernameLabel.text = thought.username
        thoughtTextLabel.text = thought.thoughtText
        likesCountLabel.text = thought.numLikes.description
    }
}
