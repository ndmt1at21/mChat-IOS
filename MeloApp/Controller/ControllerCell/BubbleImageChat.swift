//
//  BubbleImageChat.swift
//  MeloApp
//
//  Created by Minh Tri on 12/21/20.
//

import UIKit

class BubbleImageChat: BubbleBaseChat {

    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bubbleView.layer.cornerRadius = 20
        bubbleView.layer.masksToBounds = true
        
        thumbnail.contentMode = .scaleAspectFill
        progressBar.isHidden = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(bubbleImagePressed))
        bubbleView.addGestureRecognizer(tap)
    }
    
    override func setupViewCellFromMe() {
        super.setupViewCellFromMe()
    }
    
    override func setupViewCellFromFriend() {
        super.setupViewCellFromFriend()
    }
    
    override func setupContentCell() {
        super.setupContentCell()

        var url: String {
            guard let _ = messageModel?.thumbnail else {
                return messageModel!.content!
            }
            return messageModel!.thumbnail!
        }
        
        
        print("download???")
        // load image from url
        let imgLoad = ImageLoading()
        imgLoad.loadingImageAndCaching(
            target: thumbnail,
            with: url,
            placeholder: nil) { (downloaded, totalSize) in
            
            DispatchQueue.main.async {
                self.progressBar.isHidden = false
                self.progressBar.progress = Float(downloaded) / Float(totalSize)
            }
        } completion: { (error) in
            if error != nil {
                print("Error: ", error!)
                return
            }
            
            self.setNeedsLayout()
            self.progressBar.isHidden = true
        }
    }
    
    class func cellHeight(_ message: Message) -> CGFloat {
        let realWidth = message.imageWidth!
        let realHeight = message.imageHeight!
        
        let resizeWidth = 0.7 * UIScreen.main.bounds.width
        let resizeHeight = CGFloat(realHeight) * resizeWidth / CGFloat(realWidth)
        
        return resizeHeight
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
        thumbnail.kf.cancelDownloadTask()
    }
    
    @objc func bubbleImagePressed(sender: UITapGestureRecognizer) {
        delegate?.cellDidTapImage(self)
    }
}
