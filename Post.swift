//
//  Post.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Post: Object {

    @objc dynamic var post_id = ""
    @objc dynamic var postTitle = ""
    @objc dynamic var postDescription = ""
    @objc dynamic var thumbnail_url = ""
    @objc dynamic var postImage_url = ""
    @objc dynamic var postVideo_url = "" // Video is not supported at the moment
    @objc dynamic var postGif_url = ""
    @objc dynamic var created_at = NSDate()
    @objc dynamic var updated_at = NSDate()
    @objc dynamic var upvotesCount: Int = 0
    @objc dynamic var commentsCount: Int = 0
    @objc dynamic var sharesCount: Int = 0
    @objc dynamic var owner: User?
    var comments = List<Comment>()

    override static func primaryKey() -> String? {
        return "post_id"
    }

    convenience init(json: (String, JSON)) {
        self.init()
        let dict  = json.1["user"].dictionaryValue
        self.owner = User(json: dict) // <<-- could be less verbose, but the backend...
        self.post_id = json.1["video_id"].stringValue
        self.thumbnail_url = json.1["thumbnail_url"].stringValue
        self.postTitle = json.1["title"].stringValue
        self.postDescription = json.1["description"].stringValue
        self.commentsCount = json.1["comment_count"].intValue
        self.created_at = json.1["date_created"].stringValue.toSystemDate()
        self.updated_at = json.1["date_stored"].stringValue.toSystemDate()
        self.upvotesCount = json.1["likes_count"].intValue
        self.sharesCount = json.1["share_count"].intValue
        self.postImage_url = json.1["thumbnail_url"].stringValue
        self.postVideo_url = json.1["complete_url"].stringValue
        self.postGif_url = json.1["thumbnail_gif_url"].stringValue
        print(self)
    }

    convenience init(post_id: String, postTitle: String, thumbnail_url: String, postImage_url: String, postVideo_url: String, postGif_url: String, created_at: NSDate, updated_at: NSDate, postDescription: String, upvotesCount: Int, commentsCount: Int, sharesCount: Int, comments: List<Comment>) {
        self.init()
        self.post_id = post_id
        self.created_at = created_at
        self.updated_at = updated_at
        self.postTitle = postTitle
        self.postDescription = postDescription
        self.thumbnail_url = thumbnail_url
        self.postImage_url = postImage_url
        self.postGif_url = postGif_url
        self.postVideo_url = postVideo_url
        self.upvotesCount = upvotesCount
        self.commentsCount = commentsCount
        self.sharesCount = sharesCount
        self.comments = comments
    }


}
