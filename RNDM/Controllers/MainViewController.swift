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
        fetchByCategory()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        thoughtsListener.remove()
    }

    // MARK: - Methods

    private func fetchByCategory() {
        if selectedCategory == ThoughtCategory.popular.rawValue {
            sortByPopularity()
        } else {
            fetchData()
        }
    }

    private func fetchData() {
        thoughtsListener = thoughtsCollectionRef
            .whereField(DB.category, isEqualTo: selectedCategory)
            .order(by: DB.timestamp, descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    debugPrint("Error fetching documents: \(error.localizedDescription)")
                }

                self.thoughts.removeAll()
                self.thoughts = Thought.parse(snapshot)
                self.tableView.reloadData()
        }
    }

    private func sortByPopularity() {
        thoughtsListener = thoughtsCollectionRef
            .order(by: DB.numLikes, descending: true)
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    debugPrint("Error fetching documents: \(error.localizedDescription)")
                }

                self.thoughts.removeAll()
                self.thoughts = Thought.parse(snapshot)
                self.tableView.reloadData()
        }
    }

    // MARK: - IBActions

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
        fetchByCategory()
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
