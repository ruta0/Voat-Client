//
//  Comment.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Comment: Object {

    @objc dynamic var comment_id = ""
    @objc dynamic var text = ""
    @objc dynamic var created_at = NSDate()
    @objc dynamic var updated_at = NSDate()
    @objc dynamic var commentsCount: Int = 0
    @objc dynamic var upvotesCount: Int = 0
    @objc dynamic var commentImage_url = ""
    @objc dynamic var commentVideo_url = "" // Video is not supported at the moment
    @objc dynamic var commentGif_url = ""
    @objc dynamic var owner: User?
    let post = LinkingObjects(fromType: Post.self, property: "comments")

    override static func primaryKey() -> String? {
        return "comment_id"
    }

    convenience init(json: (String, JSON)) {
        self.init()
        let dict = json.1["user"].dictionaryValue
        self.owner = User(json: dict) // <<-- could be less verbose, but the backend...
        self.comment_id = json.1["comment_id"].stringValue
        self.text = json.1["body"].stringValue
        self.created_at = json.1["date_created"].stringValue.toSystemDate()
        self.updated_at = json.1["date_created"].stringValue.toSystemDate()
        self.commentsCount = json.1["comment_count"].intValue
        self.upvotesCount = json.1["score"].intValue
    }

    convenience init(comment_id: String, text: String, created_at: NSDate, updated_at: NSDate, commentsCount: Int, upvotesCount: Int) {
        self.init()
        self.comment_id = comment_id
        self.created_at = created_at
        self.updated_at = updated_at
        self.commentsCount = commentsCount
        self.text = text
        self.upvotesCount = upvotesCount
    }

}
