//
//  PostViewController.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import UIKit
import RealmSwift

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - API

    var selectedRealmPost: Post?

    var realmComments: Results<Comment>? {
        didSet {
            self.tableView.reloadData() // reload the section == 1 only
        }
    }

    // MARK: - UITableView

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.reloadData() // reload the section == 0 only
        }
    }

    private func setupTableView() {
        tableView.backgroundColor = Color.inkBlack
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let mediaCell = tableView.dequeueReusableCell(withIdentifier: MediaCell.id, for: indexPath) as? MediaCell else {
                return UITableViewCell()
            }
            mediaCell.post = self.selectedRealmPost
            return mediaCell
        } else {
            return UITableViewCell()
        }
    }

}
