//
//  UpdateCommentViewController.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 01/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Firebase

class UpdateCommentViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var updateButton: UIButton!

    var commentData: (comment: Comment, thought: Thought)?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        textView.layer.cornerRadius = 4
        updateButton.layer.cornerRadius = 5
        textView.text = commentData?.comment.commentText
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        guard
            let commentData = commentData,
            let updatedComment = textView.text else { return }
        
        Firestore.firestore()
            .collection(DB.thoughts)
            .document(commentData.thought.documentID)
            .collection(DB.comments)
            .document(commentData.comment.documentID)
            .updateData([DB.commentText: updatedComment]) { error in
                if let error = error {
                    debugPrint("Error editing comment: \(error.localizedDescription)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
        }
    }
}
