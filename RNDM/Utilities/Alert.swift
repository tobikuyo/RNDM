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

    static func editOrDelete(_ comment: Comment, for thought: Thought, with ref: DocumentReference, in vc: UIViewController) {
        let alert = UIAlertController(title: "Edit Comment",
                                      message: "You can edit or delete your comment",
                                      preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: "Edit Comment", style: .default) { action in
            vc.performSegue(withIdentifier: "EditCommentSegue", sender: (comment, thought))
            alert.dismiss(animated: true, completion: nil)
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

    static func deleteThought(_ thought: Thought, in vc: UIViewController) {
        let alert = UIAlertController(title: "Delete Thought", message: "Do you want to delete your thought?", preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in

            let thoughtRef = Firestore
                .firestore()
                .collection(DB.thoughts)
                .document(thought.documentID)

            self.delete(collection: thoughtRef.collection(DB.comments)) { error in
                if let error = error {
                    debugPrint("Error deleting thought subcollection: \(error)")
                } else {
                    thoughtRef.delete()
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }

    private static func delete(collection: CollectionReference, batchSize: Int = 100, completion: @escaping (Error?) -> ()) {
        collection.limit(to: batchSize).getDocuments { docset, error in
            guard let docset = docset else {
                completion(error)
                return
            }

            guard docset.count > 0 else {
                completion(nil)
                return
            }

            let batch = collection.firestore.batch()
            docset.documents.forEach { batch.deleteDocument($0.reference) }

            batch.commit { (batchError) in
                if let batchError = batchError {
                    completion(batchError)
                } else {
                    self.delete(collection: collection, batchSize: batchSize, completion: completion)
                }
            }
        }
    }
}
