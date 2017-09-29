//
//  ViewController.swift
//  Voat
//
//  Created by rightmeow on 8/24/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WebServiceDelegate, PersistentContainerDelegate {

    // MARK: - API

    var realmPosts: Results<Post>? {
        didSet {
            tableViewReload()
        }
    }

    // MARK: - UIRefreshControl

    @objc func handleRefresh() {
        DispatchQueue.main.async {
            self.refreshControl?.beginRefreshing()
        }
        webServiceManager?.fetchPosts(endpoint: WebServiceConfigurations.endpoint.posts.hot)
    }

    var refreshControl: UIRefreshControl?

    private func setupUIRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = Color.white
        refreshControl!.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl = refreshControl
    }

    // MARK: - PersistentContainerDelegate

    var realmManager: RealmManager?

    func containerDidErr(error: Error) {
        self.scheduleNavigationPrompt(message: error.localizedDescription, duration: 4)
    }

    func containerDidUpdateObjects() {
        realmManager?.fetchPosts(sortedKeyPath: "upvotesCount", ascending: false)
    }

    func containerDidFetchPosts(posts: Results<Post>?) {
        guard let fetchedPosts = posts else {
            print(trace(file: #file, function: #function, line: #line))
            return
        }
        self.realmPosts = fetchedPosts
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

    func webServiceDidFetchPosts(posts: Any) {
        if refreshControl != nil {
            if self.refreshControl!.isRefreshing {
                DispatchQueue.main.async {
                    self.refreshControl!.endRefreshing()
                }
            }
        }
        var realmPosts = [Post]()
        let jsonPosts = JSON(posts)["videos"]
        for jsonPost in jsonPosts {
            let realmPost = Post()
            realmPost.post_id = jsonPost.1["video_id"].stringValue
            realmPost.thumbnail_url = jsonPost.1["thumbnail_url"].stringValue
            realmPost.postTitle = jsonPost.1["title"].stringValue
            realmPost.postDescription = jsonPost.1["description"].stringValue
            realmPost.commentsCount = jsonPost.1["comment_count"].intValue
            realmPost.created_at = jsonPost.1["date_created"].stringValue.toSystemDate()
            realmPost.updated_at = jsonPost.1["date_stored"].stringValue.toSystemDate()
            realmPost.upvotesCount = jsonPost.1["likes_count"].intValue
            realmPost.sharesCount = jsonPost.1["share_count"].intValue
            realmPost.postImage_url = jsonPost.1["thumbnail_url"].stringValue
            realmPost.postVideo_url = jsonPost.1["complete_url"].stringValue
            realmPost.postGif_url = jsonPost.1["thumbnail_gif_url"].stringValue
            realmPosts.append(realmPost)
        }
        realmManager?.updateObjects(objects: realmPosts)
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

    @IBOutlet weak var tableView: UITableView!

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
        setupUIRefreshControl()
        setupWebServiceDelegate()
        setupPersistentContainerDelegate()
        webServiceManager?.fetchPosts(endpoint: WebServiceConfigurations.endpoint.posts.hot)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == seguePostCellToPostVC {
            guard let postViewController = segue.destination as? PostViewController else { return }
            if let selectedCell = sender as? PostCell, let selectedIndexPath = tableView.indexPath(for: selectedCell) {
                postViewController.selectedRealmPost = self.realmPosts?[selectedIndexPath.row]
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.realmPosts?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let postCell = tableView.dequeueReusableCell(withIdentifier: PostCell.id, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        postCell.post = realmPosts?[indexPath.row]
        return postCell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

}

