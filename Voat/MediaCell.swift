//
//  MediaCell.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MediaCell: UITableViewCell {

    // MARK: - API

    var post: Post? {
        didSet {
            updateCell()
        }
    }

    private func updateCell() {
        if let post = post {
            self.postTitleLabel.text = post.postTitle
            self.dateLabel.text = post.created_at.toRelativeDate()
            self.upvotesLabel.text = String(describing: post.upvotesCount)
            self.commentsLabel.text = String(describing: post.commentsCount)
            self.sharesLabel.text = String(describing: post.sharesCount)
            self.postDescriptionLabel.text = post.postDescription
            if !post.postImage_url.isEmpty {
                self.renderPostImageView(url: post.postImage_url)
            } else if !post.postGif_url.isEmpty {
                // implement this
            } else if !post.postVideo_url.isEmpty {
                // implement this
            }
        }
    }

    static let id = String(describing: MediaCell.self)

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var upvoteImageView: UIImageView!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!

    lazy var postImageView: UIImageView = {
        let view = UIImageView(frame: self.mediaView.frame)
        view.backgroundColor = Color.black
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    lazy var postGifView: UIImageView = {
        let view = UIImageView(frame: self.mediaView.frame)
        view.backgroundColor = Color.black
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    lazy var postVideoView: UIView = {
        let view = UIView(frame: self.mediaView.frame)
        view.backgroundColor = Color.black
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    lazy var mediaTypeImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    func renderPostImageView(url: String) {
        let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
        if let image = imageCache.image(withIdentifier: url) {
            DispatchQueue.main.async {
                self.postImageView.image = image
                self.mediaView.addSubview(self.postImageView)
                self.postImageView.fadeIn()
            }
        } else {
            Alamofire.request(url, method: HTTPMethod.get).responseImage(completionHandler: { response in
                DispatchQueue.main.async {
                    guard let image = response.result.value else {
                        print("failed to parse image from response")
                        return
                    }
                    self.postImageView.af_setImage(withURL: URL(string: url)!, placeholderImage: #imageLiteral(resourceName: "Image Placeholder"))
                    imageCache.add(image, withIdentifier: url)
                    self.postImageView.image = image
                    self.mediaView.addSubview(self.postImageView)
                    self.postImageView.fadeIn()
                }
            })
        }
    }

    func renderMediaTypeImageView() {
        if !post!.postGif_url.isEmpty {
            self.mediaTypeImageView.image = #imageLiteral(resourceName: "gif")
        } else if !post!.postVideo_url.isEmpty {
            self.mediaTypeImageView.image = #imageLiteral(resourceName: "video")
        }
    }

    private func setupCell() {
        self.backgroundColor = Color.midNightBlack
        self.postTitleLabel.textColor = Color.white
        self.userLabel.textColor = Color.lightGray
        self.dateLabel.textColor = Color.lightGray
        self.upvotesLabel.textColor = Color.lightGray
        self.commentsLabel.textColor = Color.lightGray
        self.sharesLabel.textColor = Color.lightGray
        self.upvoteImageView.tintColor = Color.lightGray
        self.commentImageView.tintColor = Color.lightGray
        self.shareImageView.tintColor = Color.lightGray
        self.postDescriptionLabel.textColor = Color.white
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

}



























