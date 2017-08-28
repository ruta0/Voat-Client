//
//  Comment.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation
import RealmSwift

class Comment: Object {

    dynamic var comment_id = ""
    dynamic var text = ""
    dynamic var created_at = NSDate()
    dynamic var updated_at = NSDate()
    dynamic var commentsCount: Int = 0
    dynamic var upvotesCount: Int = 0
    dynamic var commentImage_url = ""
    dynamic var commentVideo_url = "" // Video is not supported at the moment
    dynamic var commentGif_url = ""

    dynamic var username = ""

    let post = LinkingObjects(fromType: Post.self, property: "comments")
//    let user = LinkingObjects(fromType: User.self, property: "users")

    override static func primaryKey() -> String? {
        return "comment_id"
    }

    convenience init(comment_id: String, username: String, text: String, created_at: NSDate, updated_at: NSDate, commentsCount: Int, upvotesCount: Int) {
        self.init()
        self.comment_id = comment_id
        self.username = username
        self.created_at = created_at
        self.updated_at = updated_at
        self.commentsCount = commentsCount
        self.text = text
        self.upvotesCount = upvotesCount
    }

}
