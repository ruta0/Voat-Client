//
//  PostCell.swift
//  Voat
//
//  Created by rightmeow on 8/26/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PostCell: UITableViewCell {

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
            if !post.thumbnail_url.isEmpty {
                self.postImageView.image = nil
                let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
                if let image = imageCache.image(withIdentifier: post.thumbnail_url) {
                    DispatchQueue.main.async {
                        self.postImageView.image = image
                        self.postImageView.fadeIn()
                        self.renderMediaTypeImageView()
                    }
                } else {
                    Alamofire.request(post.thumbnail_url, method: .get).responseImage(completionHandler: { response in
                        DispatchQueue.main.async {
                            guard let image = response.result.value else {
                                print("failed to parse image from response")
                                return
                            }
                            self.postImageView.af_setImage(withURL: URL(string: post.thumbnail_url)!, placeholderImage: #imageLiteral(resourceName: "Image Placeholder"))
                            imageCache.add(image, withIdentifier: post.thumbnail_url)
                            self.postImageView.image = image
                            self.postImageView.fadeIn()
                            self.renderMediaTypeImageView()
                        }
                    })
                }
            } else {
                self.postImageView.image = nil
            }
        }
    }

    static let id = String(describing: PostCell.self)

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var mediaTypeImageView: UIImageView!
    @IBOutlet weak var upvoteImageView: UIImageView!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

    func renderMediaTypeImageView() {
        if !post!.postVideo_url.isEmpty {
            self.mediaTypeImageView.image = #imageLiteral(resourceName: "video")
        } else if !post!.postGif_url.isEmpty {
            self.mediaTypeImageView.image = #imageLiteral(resourceName: "gif")
        }
    }

    private func setupCell() {
        self.backgroundColor = Color.midNightBlack
        self.postTitleLabel.textColor = Color.white
        self.userLabel.textColor = Color.lightGray
        self.dateLabel.textColor = Color.lightGray
        self.upvotesLabel.textColor = Color.lightGray
        self.commentsLabel.textColor = Color.lightGray
        self.separatorView.backgroundColor = Color.black
        self.upvoteImageView.tintColor = Color.lightGray
        self.commentImageView.tintColor = Color.lightGray
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted == true {
            self.backgroundColor = Color.mildBlueGray
            self.postImageView.alpha = 0.5
        } else {
            self.backgroundColor = Color.midNightBlack
            self.postImageView.alpha = 1.0
        }
    }

}
