//
//  User.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {

    dynamic var user_id = ""
    dynamic var username = ""
    dynamic var created_at = NSDate()
    dynamic var updated_at = NSDate()
    

}
