//
//  UserWithLikeTableViewCell.swift
//  Blicup
//
//  Created by Guilherme Braga on 10/08/16.
//  Copyright © 2016 Moymer. All rights reserved.
//

import UIKit

@objc protocol UserWithLikeTableViewCellProtocol: class {
    func userWithLikeTableViewCellFollowPressed(cell: UserWithLikeTableViewCell)
}

class UserWithLikeTableViewCell: UITableViewCell {
    
    enum CellState {
        case None, UnFollow
    }
    
    @IBOutlet weak var ivUserPhoto: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblLikes: UILabel!
    
    @IBOutlet weak var ivVerifiedBadge: UIImageView!
    @IBOutlet weak var constrivVerifiedBadgeWidth: NSLayoutConstraint!
    let kVerifiedBadgeWidth: CGFloat = 15
    
    @IBOutlet weak var constrBtnFollowWidth: NSLayoutConstraint!
    var kDefaultWidth: CGFloat = 90
    
    weak var delegate: UserWithLikeTableViewCellProtocol?
    
    var state = CellState.UnFollow {
        didSet {
            self.confiCellBtns()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ivUserPhoto.layer.cornerRadius = self.ivUserPhoto.frame.width/2
        ivUserPhoto.layer.masksToBounds = true
        
        let title = NSLocalizedString("Follow", comment: "Follow")
        btnFollow.setTitle(title, forState: .Normal)
        btnFollow.setTitleColor(UIColor.blicupLightGray3(), forState: .Normal)
        btnFollow.setBackgroundColor(UIColor.clearColor(), forState: UIControlState.Normal)
        
        let titleSelected = NSLocalizedString("Following", comment: "Following")
        btnFollow.setTitle(titleSelected, forState: .Selected)
        btnFollow.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        btnFollow.setBackgroundColor(UIColor.blicupPink(), forState: UIControlState.Selected)
        
        btnFollow.layer.cornerRadius = btnFollow.bounds.height/2
        btnFollow.layer.borderWidth = 2.0
        
        calculateBtnFollowWidth()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        btnFollow.hidden = false
        ivUserPhoto.image = nil
        lblUsername.text = nil
    }
    
    
    // MARK: - Button Follow Configuration
    private func confiCellBtns() {
        btnFollow.hidden = (state != .UnFollow)
        constrBtnFollowWidth.constant = state == .None ? 0 : kDefaultWidth
    }
    
    func setFollowing(following:Bool) {
        btnFollow.selected = following
        btnFollow.layer.borderColor = following ? UIColor.blicupPink().CGColor : UIColor.blicupGray2().CGColor
    }
    
    func calculateBtnFollowWidth() {
        
        guard let font = self.btnFollow.titleLabel?.font else {
            return
        }
        
        let title = NSLocalizedString("Following", comment: "Following")
        
        let constraintRect = CGSize(width: CGFloat.max, height: self.btnFollow.frame.height)
        let boundingBtn = title.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        kDefaultWidth = boundingBtn.width + 25
        constrBtnFollowWidth.constant = kDefaultWidth
        self.btnFollow.layoutIfNeeded()
        
    }
    
    func showVerifiedBadge(isVerified: Bool) {
        
        self.constrivVerifiedBadgeWidth.constant = isVerified ? kVerifiedBadgeWidth : 0
        self.ivVerifiedBadge.hidden = !isVerified
        self.layoutIfNeeded()
    }
    
    // MARK: - Actions
    @IBAction func btnFollowPressed(sender: AnyObject) {
        self.delegate?.userWithLikeTableViewCellFollowPressed(self)
    }
}