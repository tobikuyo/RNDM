//
//  CommentTableViewCell.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 29/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var optionsMenuImage: UIImageView!

    func configureCell(comment: Comment) {
        usernameLabel.text = comment.username
        commentLabel.text = comment.commentText

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        let timestamp = dateFormatter.string(from: comment.timestamp)
        timestampLabel.text = timestamp

        let tap = UITapGestureRecognizer(target: self, action: #selector(optionsMenuTapped))
        optionsMenuImage.isHidden = true

        if comment.userID == Auth.auth().currentUser?.uid {
            optionsMenuImage.isHidden = false
            optionsMenuImage.isUserInteractionEnabled = true
            optionsMenuImage.addGestureRecognizer(tap)
        }
    }

    @objc func optionsMenuTapped() {
        
    }
}
