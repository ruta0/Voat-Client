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
                self.installPostImageView(url: post.postImage_url)
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
    @IBOutlet weak var mediaTypeImageView: UIImageView!
    @IBOutlet weak var upvoteImageView: UIImageView!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!

    func renderImageType() {
        if !post!.postGif_url.isEmpty {
            self.mediaTypeImageView.image = #imageLiteral(resourceName: "gif")
        } else if !post!.postVideo_url.isEmpty {
            self.mediaTypeImageView.image = #imageLiteral(resourceName: "video")
        }
    }

    func installPostImageView(url: String) {
        let imageView = UIImageView(frame: self.mediaView.frame)
        imageView.bounds = self.mediaView.bounds
        let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
        if let image = imageCache.image(withIdentifier: url) {
            DispatchQueue.main.async {
                imageView.image = image
                imageView.fadeIn()
                self.renderImageType()
            }
        } else {
            Alamofire.request(url, method: HTTPMethod.get).responseImage(completionHandler: { response in
                DispatchQueue.main.async {
                    guard let image = response.result.value else {
                        print("failed to parse image from response")
                        return
                    }
                    imageView.af_setImage(withURL: URL(string: url)!, placeholderImage: #imageLiteral(resourceName: "Image Placeholder"))
                    imageCache.add(image, withIdentifier: url)
                    imageView.image = image
                    imageView.fadeIn()
                    self.renderImageType()
                }
            })
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

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

}



























