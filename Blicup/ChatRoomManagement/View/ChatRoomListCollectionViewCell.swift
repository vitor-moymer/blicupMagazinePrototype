//
//  ChatRoomListCollectionViewCell.swift
//  Blicup
//
//  Created by Guilherme Braga on 30/03/16.
//  Copyright © 2016 Moymer. All rights reserved.
//

import UIKit

class ChatRoomListCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var ivBackground: BCGradientImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblWhoCreatedUsername: UILabel!
    @IBOutlet weak var ivWhoCreatedPhoto: UIImageView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblTagList: UILabel!
    @IBOutlet weak var lblParticipantsCount: UILabel!
    @IBOutlet weak var bcTimer: BlicupClock!
    @IBOutlet weak var ivVerifiedBadge: UIImageView!
    @IBOutlet weak var constrivVerifiedBadgeWidth: NSLayoutConstraint!
    
    let kVerifiedBadgeWidth: CGFloat = 15
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        ivBackground.runLoopMode = NSDefaultRunLoopMode
        ivBackground.needsPrescaling = false
        ivBackground.autoPlayAnimatedImage = true
        ivBackground.framePreloadCount = 2
        
        self.vContainer.layer.cornerRadius = 15
        self.vContainer.clipsToBounds = true
    }
    override func prepareForReuse() {
        ivBackground.kf_cancelDownloadTask()
        ivBackground.image = nil
    }
    
    
    func showVerifiedBadge(isVerified: Bool) {
        
        self.constrivVerifiedBadgeWidth.constant = isVerified ? kVerifiedBadgeWidth : 0
        self.ivVerifiedBadge.hidden = !isVerified
        self.layoutIfNeeded()
    }
    
    func animateHighlightCell() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95)
            }, completion: nil)
    }
    
    func animateUnhighlightCell() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
}
