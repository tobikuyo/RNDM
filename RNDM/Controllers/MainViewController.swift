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

    // MARK: - IBOutlets

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!

    // MARK: - Properties

    private var thoughts: [Thought] = []
    private let thoughtsCollectionRef = Firestore.firestore().collection(DB.thoughts)
    private var thoughtsListener: ListenerRegistration!
    private var selectedCategory = ThoughtCategory.funny.rawValue

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        thoughtsListener.remove()
    }

    // MARK: - Methods and IBActions

    private func fetchData() {
        thoughtsListener = thoughtsCollectionRef
            .whereField(DB.category, isEqualTo: selectedCategory)
            .order(by: DB.timestamp, descending: true)
            .addSnapshotListener { snapshot, error in

            if let error = error {
                debugPrint("Error fetching documents: \(error.localizedDescription)")
            }

            self.thoughts.removeAll()
            guard let documents = snapshot?.documents else { return }

            for document in documents {
                let data = document.data()
                let username = data[DB.username] as? String ?? "Anonymous"
                let timestamp = data[DB.timestamp] as? Timestamp ?? Timestamp()
                let thoughtText = data[DB.thoughtText] as? String ?? ""
                let numLikes = data[DB.numLikes] as? Int ?? 0
                let numComments = data[DB.numComments] as? Int ?? 0
                let documentID = document.documentID

                let thought = Thought(username: username,
                                      thoughtText: thoughtText,
                                      numLikes: numLikes,
                                      numComments: numComments,
                                      timestamp: timestamp.dateValue(),
                                      documentID: documentID)
                self.thoughts.append(thought)
            }

            self.tableView.reloadData()

        }
    }

    @IBAction func categoryChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.popular.rawValue
        }

        thoughtsListener.remove()
        fetchData()
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 100
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 100
        }
    }
}
