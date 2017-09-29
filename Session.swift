//
//  Session.swift
//  Voat
//
//  Created by rightmeow on 9/2/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation
import RealmSwift

class Session: Object {

    @objc dynamic var session_id = ""
    @objc dynamic var access_token = ""
    @objc dynamic var refresh_token = ""
    @objc dynamic var grant_type = ""
    @objc dynamic var secret = ""
    @objc dynamic var pin = ""
    @objc dynamic var expires_in: Int = 0
    @objc dynamic var created_at = NSDate()
    @objc dynamic var updated_at = NSDate()

    let user = LinkingObjects(fromType: User.self, property: "sessions")

    override static func primaryKey() -> String? {
        return "session_id"
    }

}
