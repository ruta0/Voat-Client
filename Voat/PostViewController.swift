//
//  PostViewController.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

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
        self.scheduleNavigationPrompt(message: error.localizedDescription, duration: 4)
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

    var webServiceManager: WebServiceManager?

    func webServiceDidErr(error: Error) {
        self.scheduleNavigationPrompt(message: error.localizedDescription, duration: 4)
    }

    func webServiceDidFetchComments(comments: Any) {
        var realmComments = [Comment]()
        let jsonComments = JSON(comments)["comments"]
        for jsonComment in jsonComments {
            let realmComment = Comment()
            realmComment.comment_id = jsonComment.1["comment_id"].stringValue
            realmComment.text = jsonComment.1["body"].stringValue
            realmComment.created_at = jsonComment.1["date_created"].stringValue.toSystemDate()
            realmComment.updated_at = jsonComment.1["date_created"].stringValue.toSystemDate()
            realmComment.commentsCount = jsonComment.1["comment_count"].intValue
            realmComment.upvotesCount = jsonComment.1["score"].intValue
            realmComments.append(realmComment)
        }
        realmManager?.updateObjects(objects: realmComments)
    }

    private func setupWebServiceDelegate() {
        webServiceManager = WebServiceManager()
        webServiceManager!.delegate = self
    }

    // MARK: - UINavigationController

    private var timer: Timer?

    func scheduleNavigationPrompt(message: String, duration: TimeInterval) {
        DispatchQueue.main.async {
            self.navigationItem.prompt = message
            self.timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.removeNavigationPrompt), userInfo: nil, repeats: false)
            self.timer?.tolerance = 5
        }
    }

    @objc private func removeNavigationPrompt() {
        if navigationItem.prompt != nil {
            DispatchQueue.main.async {
                self.navigationItem.prompt = nil
            }
        }
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




















