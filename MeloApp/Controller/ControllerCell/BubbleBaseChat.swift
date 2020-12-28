//
//  BubbleBaseChat.swift
//  MeloApp
//
//  Created by Minh Tri on 12/24/20.
//

import UIKit
import Kingfisher
import Firebase

class BubbleBaseChat: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet var leftConstraintToViewCell: NSLayoutConstraint!
    @IBOutlet var rightConstraintToStatusCircle: NSLayoutConstraint!
    @IBOutlet weak var sendingStatusCircle: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var bubbleView: UIView!
    
    var delegate: BubbleBaseChatDelegate?
    var messageModel: Message? = nil {
        didSet {
            setupContentCell()
            layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(avatarImageTaped))
        
        let longPressBubble = UILongPressGestureRecognizer(target: self, action: #selector(longPressBubbleView))
        
        self.avatar.layer.cornerRadius = avatar.layer.frame.height / 2
        self.avatar.isUserInteractionEnabled = true
        self.avatar.addGestureRecognizer(tapAvatar)
        
        self.bubbleView.addGestureRecognizer(longPressBubble)
        progressBar.progress = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        if let currentUser = Auth.auth().currentUser {
            if messageModel?.sendBy! == currentUser.uid {
                setupViewCellFromMe()
            } else {
                setupViewCellFromFriend()
            }
        }
    }
    
    internal func setupViewCellFromMe() {
        avatar.isHidden = true
        leftConstraintToViewCell.isActive = false
        rightConstraintToStatusCircle.isActive = true
        sendingStatusCircle.isHidden = false
    }
    
    internal func setupViewCellFromFriend() {
        avatar.isHidden = false
        leftConstraintToViewCell.isActive = true
        rightConstraintToStatusCircle.isActive = false
        sendingStatusCircle.isHidden = true
    }
    
    internal func setupContentCell() {
        // load avatar
        let imgLoading = ImageLoading()

        imgLoading.loadingImageAndCaching(
            target: avatar,
            with: AuthController.shared.currentUser?.profileImage,
            placeholder: nil
        ) { (_, _) in

        } completion: { (error) in
            if error != nil {
                print("Error: ", error!)
            }
            self.setNeedsLayout()
        }
    }
    
    @objc func avatarImageTaped(sender: UITapGestureRecognizer) {
        delegate?.cellDidTapAvatar(self)
    }
    
    @objc func longPressBubbleView(sender: UITapGestureRecognizer) {
        delegate?.cellLongPress(self)
    }
}
