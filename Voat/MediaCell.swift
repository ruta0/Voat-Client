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
import AVFoundation
import FLAnimatedImage

class MediaCell: UITableViewCell {

    // MARK: - API

    var post: Post? {
        didSet {
            updateCell()
        }
    }

    var avPlayer: AVPlayer?

    private func updateCell() {
        if let post = post {
            self.userLabel.text = post.owner?.username
            self.postTitleLabel.text = post.postTitle
            self.dateLabel.text = post.created_at.toRelativeDate()
            self.upvotesLabel.text = String(describing: post.upvotesCount)
            self.commentsLabel.text = String(describing: post.commentsCount)
            self.sharesLabel.text = String(describing: post.sharesCount)
            self.postDescriptionLabel.text = post.postDescription
            if !post.postGif_url.isEmpty {
                self.renderPostGifImageView(url: post.postGif_url)
            } else if !post.postImage_url.isEmpty {
                self.renderPostImageView(url: post.postImage_url)
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

    lazy var postGifImageView: FLAnimatedImageView = {
        let view = FLAnimatedImageView(frame: self.mediaView.frame)
        view.backgroundColor = Color.black
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    lazy var postVideoView: UIView = {
        let view = UIView(frame: self.mediaView.frame)
        view.backgroundColor = Color.orange
        view.contentMode = UIViewContentMode.scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    lazy var postVideoWebView: UIWebView = {
        let view = UIWebView(frame: self.mediaView.frame)
        view.backgroundColor = Color.black
        view.contentMode = UIViewContentMode.scaleAspectFill
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

    func renderPostGifImageView(url: String) {
        Alamofire.request(url, method: HTTPMethod.get).responseData(completionHandler: { response in
            switch response.result {
            case .success:
                guard let data = response.result.value else {
                    DispatchQueue.main.async {
                        self.postGifImageView.image = #imageLiteral(resourceName: "error") // <<-- image literal
                        self.postGifImageView.contentMode = .center
                        self.mediaView.addSubview(self.postGifImageView)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.postGifImageView.animatedImage = FLAnimatedImage(animatedGIFData: data, optimalFrameCacheSize: 100_000, predrawingEnabled: true)
                    self.mediaView.addSubview(self.postGifImageView)
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.postGifImageView.image = #imageLiteral(resourceName: "error") // <<-- image literal
                    self.postGifImageView.contentMode = .center
                    self.mediaView.addSubview(self.postGifImageView)
                }
            }
        })
    }

    func renderPostVideoView(url: String) {
        let url = URL(fileURLWithPath: url)
        self.avPlayer = AVPlayer(url: url)
        let avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
        avPlayerLayer.frame = self.postVideoView.frame
        self.postVideoView.layer.addSublayer(avPlayerLayer)
        self.mediaView.addSubview(self.postVideoView)
        self.playVideo()
    }

    func playVideo() {
        DispatchQueue.main.async {
            self.avPlayer?.play()
        }
    }

    func pauseVideo() {
        DispatchQueue.main.async {
            self.avPlayer?.pause()
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

    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text?.removeAll()
        userLabel.text?.removeAll()
        dateLabel.text?.removeAll()
        upvotesLabel.text?.removeAll()
        commentsLabel.text?.removeAll()
        sharesLabel.text?.removeAll()
        postDescriptionLabel.text?.removeAll()
    }

}



























