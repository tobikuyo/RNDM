//
//  LoginViewController.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 28/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var createUserButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        createUserButton.layer.cornerRadius = 5
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
    }

    @IBAction func createUserButtonTapped(_ sender: Any) {
    }
}
