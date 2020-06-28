//
//  CreateUserViewController.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 28/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateUserViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
    }
    
    @IBAction func createUserButtonTapped(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let username = usernameTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                debugPrint("Error creating user: \(error.localizedDescription)")
            }

            let changeRequest = user?.user.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { error in
                if let error = error {
                    debugPrint("Error adding display name: \(error.localizedDescription)")
                }
            })

            guard let userID = user?.user.uid else { return }

            Firestore.firestore().collection(DB.users).document(userID).setData([
                DB.username: username,
                DB.dateCreated: FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    debugPrint("Error setting username: \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
