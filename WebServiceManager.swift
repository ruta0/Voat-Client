//
//  WebServiceManager.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import Foundation
import Alamofire

protocol WebServiceDelegate: NSObjectProtocol {
    func webServiceDidErr(error: Error)
    // posts
    func webServiceDidFetchPosts(posts: Any)
    func webServiceDidCreatePost(post: Any)
    func webServiceDidUpdatePost(post: Any)
    func webServiceDidDeletePost()
    // user(s)
    func webService(_ manager: WebServiceManager, didLogin user: User)
    func webService(_ manager: WebServiceManager, didSignup user: User)
    // comments
    func webServiceDidFetchComments(comments: Any)
    // ...
}

extension WebServiceDelegate {
    // posts
    func webServiceDidFetchPosts(posts: Any) {}
    func webServiceDidCreatePost(post: Any) {}
    func webServiceDidUpdatePost(post: Any) {}
    func webServiceDidDeletePost() {}
    // user(s)
    func webService(_ manager: WebServiceManager, didLogin user: User) {}
    func webService(_ manager: WebServiceManager, didSignup user: User) {}
    // comments
    func webServiceDidFetchComments(comments: Any) {}
    // ...
}

class WebServiceManager: NSObject {

    weak var delegate: WebServiceDelegate?

    private func configureURL(endpoint: String) -> String {
        let url = WebServiceConfigurations.baseURL + endpoint
        return url
    }

    // MARK: - Get

    func fetchPosts(endpoint: String) {
        let url = configureURL(endpoint: endpoint)
        Alamofire.request(url, method: HTTPMethod.get, parameters: WebServiceConfigurations.paramater.platform, encoding: URLEncoding.queryString, headers: WebServiceConfigurations.header.authorization).responseJSON { response in
            switch response.result {
            case .success(let value):
                self.delegate?.webServiceDidFetchPosts(posts: value)
            case .failure(let error):
                self.delegate?.webServiceDidErr(error: error)
            }
        }
    }

    func fetchComments(endpoint: String, selectedPostID: String) {
        let url = configureURL(endpoint: endpoint) + "/" + selectedPostID + WebServiceConfigurations.endpoint.comments.comments
        Alamofire.request(url, method: HTTPMethod.get, parameters: WebServiceConfigurations.paramater.platform, encoding: URLEncoding.queryString, headers: WebServiceConfigurations.header.authorization).responseJSON { response in
            switch response.result {
            case .success(let value):
                self.delegate?.webServiceDidFetchComments(comments: value)
            case .failure(let error):
                self.delegate?.webServiceDidErr(error: error)
            }
        }
    }

    // MARK: - Update

    // MARK: - Delete
    
    // MARK: - Auth

    @objc func login(endpoint: String, user: String, pass: String) {

    }
    
    // ...

}

struct WebServiceConfigurations {

    static let baseURL = "https://api.vid.me"
    static let api_version = "1"

    struct endpoint {
        struct posts {
            static let hot = "/videos/hot"
            static let new = "/videos/new"
            static let post = "/video"
        }
        struct comments {
            static let comments = "/comments"
        }
    }

    struct paramater {
        static let platform = ["PLATFORM" : "ios"]
    }

    struct header {
        static let authorization = ["Authorization" : ""]
    }
    
}



















