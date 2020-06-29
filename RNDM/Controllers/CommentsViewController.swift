//
//  CommentsViewController.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 29/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CommentsViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet var tableView: UITableView!
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet weak var keyboardView: UIView!

    // MARK: - Properties
    
    var thought: Thought!
    var username: String!
    var comments: [Comment] = []
    var thoughtRef: DocumentReference!
    let database = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        pathToAddComment()
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func pathToAddComment() {
        guard let username = Auth.auth().currentUser?.displayName else { return }

        thoughtRef = database.collection(DB.thoughts).document(thought.documentID)
        self.username = username
    }

    @IBAction func addCommentTapped(_ sender: Any) {
        guard let commentText = commentTextField.text else { return }

        database.runTransaction({ transaction, errorPointer -> Any? in
            let thoughtDocument: DocumentSnapshot

            do {
                try thoughtDocument = transaction.getDocument(self.database
                        .collection(DB.thoughts)
                        .document(self.thought.documentID))
            } catch {
                debugPrint("Error fetching comments: \(error.localizedDescription)")
                return nil
            }

            guard let oldCommentCount = thoughtDocument.data()?[DB.numComments] as? Int else { return nil }

            transaction.updateData([DB.numComments: oldCommentCount + 1], forDocument: self.thoughtRef)

            let newCommentRef = self.database
                .collection(DB.thoughts)
                .document(self.thought.documentID)
                .collection(DB.comments)
                .document()

            transaction.setData([
                DB.commentText: commentText,
                DB.timestamp: FieldValue.serverTimestamp(),
                DB.username: self.username ?? "Anonymous"
            ], forDocument: newCommentRef, merge: true)
            return nil
        }) { object, error in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
            } else {
                self.commentTextField.text = ""
            }
        }
    }
}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }

        let comment = comments[indexPath.row]
        cell.configureCell(comment: comment)
        return cell
    }
}
