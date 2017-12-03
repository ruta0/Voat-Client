//
//  User.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class User: Object {

    @objc dynamic var user_id = ""
    @objc dynamic var username = ""
    @objc dynamic var created_at = NSDate()
    @objc dynamic var updated_at = NSDate()

    var sessions = List<Session>()

    convenience init(json: [String : JSON]) {
        self.init()
        self.user_id = json["user_id"]?.stringValue ?? ""
        self.username = json["username"]?.stringValue ?? ""
        self.created_at = NSDate()
        self.updated_at = NSDate()
    }

    override static func primaryKey() -> String? {
        return "user_id"
    }

}
