//
//  Alert.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 01/07/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Firebase

struct Alert {

    static func editOrDelete(_ comment: Comment, for thought: Thought, using ref: DocumentReference, in vc: UIViewController) {
        let alert = UIAlertController(title: "Edit Comment",
                                      message: "You can edit or delete your comment",
                                      preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: "Edit Comment", style: .default) { action in

        }

        let deleteAction = UIAlertAction(title: "Delete Comment", style: .destructive) { action in
            let database = Firestore.firestore()
            database.runTransaction({ transaction, errorPointer -> Any? in
                let thoughtDocument: DocumentSnapshot

                do {
                    try thoughtDocument = transaction.getDocument(database
                        .collection(DB.thoughts)
                        .document(thought.documentID))
                } catch {
                    debugPrint("Error fetching comments: \(error.localizedDescription)")
                    return nil
                }

                guard let oldCommentCount = thoughtDocument.data()?[DB.numComments] as? Int else { return nil }

                let commentRef = database
                    .collection(DB.thoughts)
                    .document(thought.documentID)
                    .collection(DB.comments)
                    .document(comment.documentID)

                transaction.updateData([DB.numComments: oldCommentCount - 1], forDocument: ref)
                transaction.deleteDocument(commentRef)
                return nil
            }) { object, error in
                if let error = error {
                    debugPrint("Error deleting comment: \(error)")
                } else {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
