//
//  MainViewController.swift
//  RNDM
//
//  Created by Tobi Kuyoro on 27/06/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!

    private var thoughts: [Thought] = []
    private let thoughtsCollectionRef = Firestore.firestore().collection(K.thoughts)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    private func fetchData() {
        thoughtsCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                debugPrint("Error fetching documents: \(error.localizedDescription)")
            }

            guard let documents = snapshot?.documents else { return }

            for document in documents {
                let data = document.data()
                let username = data[K.username] as? String ?? "Anonymous"
                let timestamp = data[K.timestamp] as? Date ?? Date()
                let thoughtText = data[K.thoughtText] as? String ?? ""
                let numLikes = data[K.numLikes] as? Int ?? 0
                let numComments = data[K.numComments] as? Int ?? 0
                let documentID = document.documentID

                let thought = Thought(username: username,
                                      thoughtText: thoughtText,
                                      numLikes: numLikes,
                                      numComments: numComments,
                                      timestamp: timestamp,
                                      documentID: documentID)
                self.thoughts.append(thought)
            }

            self.tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as? ThoughtTableViewCell else {
            return UITableViewCell()
        }

        let thought = thoughts[indexPath.row]
        cell.configureCell(thought: thought)
        return cell
    }
}
