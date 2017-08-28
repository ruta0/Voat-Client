//
//  PostViewController.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import UIKit
import RealmSwift

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WebServiceDelegate, PersistentContainerDelegate {

    // MARK: - API

    var selectedRealmPost: Post?

    var realmComments: Results<Comment>? {
        didSet {
            self.tableViewReload() // reload the section == 1 only
        }
    }

    // MARK: - PersistentContainerDelegate

    var realmManager: RealmManager?

    func containerDidErr(error: Error) {
        print(error.localizedDescription)
    }

    func containerDidUpdateObjects() {
        realmManager?.fetchComments(sortedKeyPath: "upvotesCount", ascending: false)
    }

    func containerDidFetchComments(comments: Results<Comment>?) {
        guard let fetchedComments = comments else {
            print(trace(file: #file, function: #function, line: #line))
            return
        }
        self.realmComments = fetchedComments
    }

    private func setupPersistentContainerDelegate() {
        realmManager = RealmManager()
        realmManager!.delegate = self
    }

    // MARK: - WebServiceDelegate

    var webServiceManager: WebServerManager?

    func webServiceDidErr(error: Error) {
        print(error.localizedDescription)
    }

    func webServiceDidFetchComments(comments: [NSDictionary]) {
        var realmComments = [Comment]()
        for comment in comments {
            if let comment_id = comment["comment_id"] as? String, let text = comment["body"] as? String, let created_at = comment["date_created"] as? String, let updated_at = comment["date_created"] as? String, let commentsCount = comment["comment_count"] as? Int, let upvotesCount = comment["score"] as? Int {
                let realmComment = Comment()
                realmComment.comment_id = comment_id
                realmComment.text = text
                realmComment.created_at = created_at.toSystemDate()
                realmComment.updated_at = updated_at.toSystemDate()
                realmComment.commentsCount = commentsCount
                realmComment.upvotesCount = upvotesCount
                realmComments.append(realmComment)
            }
        }
        realmManager?.updateObjects(objects: realmComments)
    }

    private func setupWebServiceDelegate() {
        webServiceManager = WebServerManager()
        webServiceManager!.delegate = self
    }

    // MARK: - UITableView

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.reloadData() // reload the section == 0 only
        }
    }

    func tableViewReload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func setupTableView() {
        tableView.backgroundColor = Color.inkBlack
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupWebServiceDelegate()
        setupPersistentContainerDelegate()
        guard let post_id = selectedRealmPost?.post_id else { return }
        webServiceManager?.fetchComments(endpoint: WebServiceConfigurations.endpoint.posts.post, selectedPostID: post_id)
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
        if section == 0 {
            return 1
        } else {
            return realmComments?.count ?? 0
        }
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
        } else if indexPath.section == 1 {
            guard let commentCell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id, for: indexPath) as? CommentCell else {
                return UITableViewCell()
            }
            commentCell.comment = self.realmComments?[indexPath.row]
            return commentCell
        } else {
            return UITableViewCell()
        }
    }

}




















