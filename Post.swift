//
//  Post.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation
import RealmSwift

class Post: Object {

    dynamic var post_id = ""
    dynamic var postTitle = ""
    dynamic var postDescription = ""
    dynamic var thumbnail_url = ""
    dynamic var postImage_url = ""
    dynamic var postVideo_url = "" // Video is not supported at the moment
    dynamic var postGif_url = ""
    dynamic var created_at = NSDate()
    dynamic var updated_at = NSDate()
    dynamic var upvotesCount: Int = 0
    dynamic var commentsCount: Int = 0
    dynamic var sharesCount: Int = 0

    var comments = List<Comment>()
//    var user = LinkingObjects(fromType: User.self, property: "posts")

    override static func primaryKey() -> String? {
        return "post_id"
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
