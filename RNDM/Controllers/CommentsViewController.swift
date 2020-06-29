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
    var comments: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func addCommentTapped(_ sender: Any) {
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
