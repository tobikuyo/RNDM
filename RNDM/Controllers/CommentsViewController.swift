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

    @IBOutlet var tableView: UITableView!
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet var keyboardView: UIView!

    // MARK: - Properties
    
    var thought: Thought!
    var username: String!
    var comments: [Comment] = []
    var thoughtRef: DocumentReference!
    var commentListener: ListenerRegistration!
    let database = Firestore.firestore()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        pathToAddComment()
        tableView.delegate = self
        tableView.dataSource = self
        view.bindToKeyboard()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setListener()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        commentListener.remove()
    }

    // MARK: - Methods

    private func pathToAddComment() {
        guard let username = Auth.auth().currentUser?.displayName else { return }

        thoughtRef = database.collection(DB.thoughts).document(thought.documentID)
        self.username = username
    }

    private func setListener() {
        commentListener = database
            .collection(DB.thoughts)
            .document(self.thought.documentID)
            .collection(DB.comments)
            .order(by: DB.timestamp, descending: true)
            .addSnapshotListener({ snapShot, error in
                guard let snapShot = snapShot else {
                    debugPrint("Error fetching comments: \(error!)")
                    return
                }

                self.comments.removeAll()
                self.comments = Comment.parse(snapShot)
                self.tableView.reloadData()
            })
    }

    // MARK: - IBActions

    @IBAction func addCommentTapped(_ sender: Any) {
        guard let commentText = commentTextField.text else { return }

        database.runTransaction({ transaction, errorPointer -> Any? in
            let thoughtDocument: DocumentSnapshot

            do {
                try thoughtDocument = transaction.getDocument(self
                    .database
                    .collection(DB.thoughts)
                    .document(self.thought.documentID))
            } catch {
                debugPrint("Error fetching comments: \(error.localizedDescription)")
                return nil
            }

            guard let oldCommentCount = thoughtDocument.data()?[DB.numComments] as? Int else { return nil }

            transaction.updateData([DB.numComments: oldCommentCount + 1], forDocument: self.thoughtRef)

            let newCommentRef = self
                .database
                .collection(DB.thoughts)
                .document(self.thought.documentID)
                .collection(DB.comments)
                .document()

            transaction.setData([
                DB.commentText: commentText,
                DB.timestamp: FieldValue.serverTimestamp(),
                DB.username: self.username ?? "Anonymous",
                DB.userID: Auth.auth().currentUser?.uid ?? ""
            ], forDocument: newCommentRef, merge: true)
            return nil
        }) { object, error in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
            } else {
                self.commentTextField.text = ""
                self.commentTextField.resignFirstResponder()
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
        cell.configureCell(comment: comment, delegate: self)
        return cell
    }
}
