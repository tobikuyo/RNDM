//
//  AddThoughtViewController.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 27/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet var categorySegment: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var thoughtTextView: UITextView!
    @IBOutlet var postButton: UIButton!

    // MARK: - Properties

    private let database = Firestore.firestore()
    private var selectedCategory = ThoughtCategory.funny.rawValue

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - Methods

    func updateViews() {
        postButton.layer.cornerRadius = 5
        thoughtTextView.layer.cornerRadius = 4
        thoughtTextView.text = "My random thought..."
        thoughtTextView.textColor = .lightGray
        thoughtTextView.delegate = self
    }

    // MARK: - IBActions

    @IBAction func categoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        default:
            selectedCategory = ThoughtCategory.crazy.rawValue
        }
    }

    @IBAction func postButtonTapped(_ sender: Any) {
        guard
            let thoughtText = thoughtTextView.text,
            let username = usernameTextField.text else { return }

        database.collection(K.thoughts).addDocument(data: [
            K.category: selectedCategory,
            K.numComments: 0,
            K.numLikes: 0,
            K.thoughtText: thoughtText,
            K.timestamp: FieldValue.serverTimestamp(),
            K.username: username
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddThoughtViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .darkGray
    }
}
