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

    func handleRefresh() {
        DispatchQueue.main.async {
            self.refreshControl?.beginRefreshing()
        }
        webServiceManager?.fetchPosts(endpoint: WebServiceConfigurations.endpoint.posts.hot)
    }

    var refreshControl: UIRefreshControl?

    private func setupUIRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = Color.white
        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl = refreshControl
    }

    // MARK: - PersistentContainerDelegate

    var realmManager: RealmManager?

    func containerDidErr(error: Error) {
        print(error.localizedDescription)
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

    var webServiceManager: WebServerManager?

    func webServiceDidErr(error: Error) {
        print(error.localizedDescription)
    }

    func webServiceDidFetchPosts(posts: [NSDictionary]) {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
        var realmPosts = [Post]()
        for post in posts {
            if let post_id = post["video_id"] as? String, let thumbnail_url = post["thumbnail_url"] as? String, let postTitle = post["title"] as? String, let postDescription = post["description"] as? String, let created_at = post["date_created"] as? String, let updated_at = post["date_stored"] as? String, let upvotesCount = post["likes_count"] as? Int, let commentsCount = post["comment_count"] as? Int, let sharesCount = post["share_count"] as? Int {
                let realmPost = Post()
                realmPost.post_id = post_id
                realmPost.thumbnail_url = thumbnail_url
                realmPost.postTitle = postTitle
                realmPost.postDescription = postDescription
                realmPost.commentsCount = commentsCount
                realmPost.created_at = created_at.toSystemDate()
                realmPost.updated_at = updated_at.toSystemDate()
                realmPost.upvotesCount = upvotesCount
                realmPost.sharesCount = sharesCount

                if let postImage_url = post["thumbnail_url"] as? String {
                    realmPost.postImage_url = postImage_url
                }
                if let postVideo_url = post["complete_url"] as? String {
                    realmPost.postVideo_url = postVideo_url
                }
                if let postGif_url = post["thumbnail_gif_url"] as? String {
                    realmPost.postGif_url = postGif_url
                }

                realmPosts.append(realmPost)
            }
        }
        realmManager?.updateObjects(objects: realmPosts)
    }

    private func setupWebServiceDelegate() {
        webServiceManager = WebServerManager()
        webServiceManager!.delegate = self
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

//        print(realmManager?.pathForContainer())
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
        return 44
    }

}

