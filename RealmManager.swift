//
//  RealmManager.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation
import RealmSwift

protocol PersistentContainerDelegate {
    func containerDidErr(error: Error)
    func containerDidFetchPosts(posts: Results<Post>?)
    func containerDidUpdateObjects()
    func containerDidDeletePosts()

    func containerDidFetchComments(comments: Results<Comment>?)
    func containerDidDeleteComments()
}

extension PersistentContainerDelegate {
    func containerDidFetchPosts(posts: Results<Post>?) {}
    func containerDidUpdateObjects() {}
    func containerDidDeletePosts() {}

    func containerDidFetchComments(comments: Results<Comment>?) {}
    func containerDidDeleteComments() {}
}

var realm = try! Realm() // manual handle migration

class RealmManager: NSObject {

    var delegate: PersistentContainerDelegate?

    // MARK: - Database wildcard methods

    func pathForContainer() -> URL {
        if let path = Realm.Configuration.defaultConfiguration.fileURL {
            return path
        } else {
            print(trace(file: #file, function: #function, line: #line))
            fatalError("No realm database found")
        }
    }

    func deleteDatabase() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch let err {
            delegate?.containerDidErr(error: err)
        }
    }

    // MARK: - Get

    func fetchPosts(sortedKeyPath: String, ascending: Bool) {
        let posts = realm.objects(Post.self).sorted(byKeyPath: sortedKeyPath, ascending: ascending)
        delegate?.containerDidFetchPosts(posts: posts)
    }

    func fetchComments(sortedKeyPath: String, ascending: Bool) {
        let comments = realm.objects(Comment.self).sorted(byKeyPath: sortedKeyPath, ascending: ascending)
        delegate?.containerDidFetchComments(comments: comments)
    }

    // MARK: - Update & Create

    func updateObjects(objects: [Object]) {
        do {
            try realm.write {
                realm.add(objects, update: true)
            }
            delegate?.containerDidUpdateObjects()
        } catch let err {
            delegate?.containerDidErr(error: err)
        }
    }

    // MARK: - Delete

    func deleteObjects(objects: [Object]) {
        do {
            try realm.write {
                realm.delete(objects)
            }
            delegate?.containerDidDeletePosts()
        } catch let err {
            delegate?.containerDidErr(error: err)
        }
    }
    
    // MARK: - Auth
    
    // ...
    
}


















