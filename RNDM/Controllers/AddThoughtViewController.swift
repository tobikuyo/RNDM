//
//  AddThoughtViewController.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 27/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class AddThoughtViewController: UIViewController {

    @IBOutlet var categorySegment: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var thoughtTextView: UITextView!
    @IBOutlet var postButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        postButton.layer.cornerRadius = 5
        thoughtTextView.layer.cornerRadius = 4
        thoughtTextView.text = "My random thought..."
        thoughtTextView.textColor = .lightGray
        thoughtTextView.delegate = self
    }

    @IBAction func categoryChanged(_ sender: Any) {
    }

    @IBAction func postButtonTapped(_ sender: Any) {
    }
}

extension AddThoughtViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .darkGray
    }
}
