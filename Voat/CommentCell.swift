//
//  CommentCell.swift
//  Voat
//
//  Created by rightmeow on 8/27/17.
//  Copyright © 2017 Duckensburg. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    var comment: Comment? {
        didSet {
            updateCell()
        }
    }

    private func updateCell() {
        if let comment = comment {
            self.userLabel.text = comment.owner?.username
            self.dateLabel.text = comment.created_at.toRelativeDate()
            self.commentDescriptionLabel.text = comment.text
            self.upvotesLabel.text = String(describing: comment.upvotesCount)
        }
    }

    @IBAction func handleUpvote(_ sender: UIButton) {
        print(123)
    }

    @IBAction func handleReply(_ sender: UIButton) {
        print(123)
    }

    @IBAction func handleMore(_ sender: UIButton) {
        print(123)
    }

    static let id = String(describing: CommentCell.self)

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentDescriptionLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var upvotesLabel: UILabel!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!

    private func setupCell() {
        self.backgroundColor = Color.midNightBlack
        self.userLabel.textColor = Color.lightGray
        self.dateLabel.textColor = Color.lightGray
        self.commentDescriptionLabel.textColor = Color.white
        self.upvotesLabel.textColor = Color.lightGray
        self.upvoteButton.tintColor = Color.lightGray
        self.downvoteButton.tintColor = Color.lightGray
        self.replyButton.tintColor = Color.lightGray
        self.moreButton.tintColor = Color.lightGray
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.userLabel.text?.removeAll()
        self.dateLabel.text?.removeAll()
        self.commentDescriptionLabel.text?.removeAll()
        self.upvotesLabel.text?.removeAll()
    }

}
