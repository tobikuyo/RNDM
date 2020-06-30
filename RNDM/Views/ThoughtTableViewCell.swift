//
//  ThoughtTableViewCell.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 28/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Firebase

class ThoughtTableViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var thoughtTextLabel: UILabel!
    @IBOutlet var likesImage: UIImageView!
    @IBOutlet var likesCountLabel: UILabel!
    @IBOutlet var commentCountLabel: UILabel!
    @IBOutlet var optionsMenuImage: UIImageView!
    
    private var thought: Thought!

    override func awakeFromNib() {
        super.awakeFromNib()

        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likesImage.addGestureRecognizer(tap)
        likesImage.isUserInteractionEnabled = true
    }

    @objc func likeTapped() {
         Firestore.firestore()
            .collection(DB.thoughts)
            .document(thought.documentID)
            .updateData([DB.numLikes: thought.numLikes + 1]) { error in
                if let error = error {
                    print("Error updating like count: \(error)")
                }
        }
    }

    func configureCell(thought: Thought) {
        self.thought = thought

        usernameLabel.text = thought.username
        thoughtTextLabel.text = thought.thoughtText
        likesCountLabel.text = thought.numLikes.description
        commentCountLabel.text = thought.numComments.description

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        let timestamp = dateFormatter.string(from: thought.timestamp)
        timestampLabel.text = timestamp
    }
}
