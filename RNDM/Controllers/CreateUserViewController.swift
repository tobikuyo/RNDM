//
//  CreateUserViewController.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 28/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

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
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
}
