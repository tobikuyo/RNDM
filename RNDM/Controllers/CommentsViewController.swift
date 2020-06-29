//
//  CommentsViewController.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 29/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet weak var keyboardView: UIView!
    
    var thought: Thought?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addCommentTapped(_ sender: Any) {
    }
}
