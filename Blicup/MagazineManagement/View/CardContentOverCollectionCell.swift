//
//  CardContentOverCollectionCell.swift
//  Blicup
//
//  Created by Moymer on 8/31/16.
//  Copyright © 2016 Moymer. All rights reserved.
//

import UIKit
import Photos
class CardContentOverCollectionCell: UICollectionViewCell {


    @IBOutlet weak var ivPhoto: ScrollableImageView!
    @IBOutlet weak var lblCardTitle: UILabel!
    @IBOutlet weak var lblCardInfoText: UILabel!
    @IBOutlet weak var vTextsContainer: UIView!
    @IBOutlet weak var vVideo: FullscreenVideoView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    override func prepareForReuse() {
        ivPhoto.setImage(nil)
    }
    
    func setTexts(title:String, infoText:String) {
        lblCardTitle.text = title
        
        lblCardInfoText.text = infoText
        lblCardInfoText.sizeToFit()
        lblCardInfoText.layoutIfNeeded()
      
        setMockImage()
    }
    
    func setContentForPreview(card : [String:AnyObject], imageManager:PHCachingImageManager)
    {
        let asset : PHAsset = card["midia"] as! PHAsset
        let title : String = card["title"] as! String
        let infoText : String = card["infoText"] as! String
        
        lblCardTitle.text = title
        
        lblCardInfoText.text = infoText
        lblCardInfoText.sizeToFit()
        lblCardInfoText.layoutIfNeeded()
        
        if asset.mediaType == PHAssetMediaType.Image {
            vVideo.hidden = true
            ivPhoto.hidden = false
            ivPhoto.imageManager = imageManager
            ivPhoto.setPositioningScale(ScrollableImageViewPosAndScale.ASPECT_FILL)
            ivPhoto.setImageFromAsset(asset)
        } else {
            ivPhoto.hidden = true
            vVideo.hidden = false
            vVideo.imageManager = imageManager
            vVideo.phAsset = asset
        }
        
    }
    
    private func setMockImage()
    {
       ivPhoto.setImageFromUrls(nil, photoUrl: NSURL(string: "http://www.cbc.ca/documentaries/content/images/blog/greatbarrierreef1_1920.jpg")!)
    }
    



    /**
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return ivPhoto
    }
 **/
}
