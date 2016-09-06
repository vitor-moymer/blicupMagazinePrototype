//
//  ArticlesReadingCollectionViewController.swift
//  Blicup
//
//  Created by Moymer on 8/31/16.
//  Copyright © 2016 Moymer. All rights reserved.
//

import UIKit
import Photos


private let reuseIdentifierOver = "CardOverCell"
private let reuseIdentifierSplited = "CardSplitCell"



enum CardMode : Int  {

    case OverCellLayout = 0
    
    case SplitCellLayout
    
    
    enum OverCellDesign : Int {
        case Dark = 0
        case Light
        case Midia
        case MidiaGradient
        
        static var count: Int { return CardMode.OverCellDesign.MidiaGradient.hashValue + 1}
    }
    enum SplitCellDesign : Int {
        case Dark = 0
        case Light
        case Midia
        static var count: Int { return CardMode.SplitCellDesign.Midia.hashValue + 1}
    }
    
    static var count: Int { return CardMode.SplitCellLayout.hashValue + 1}

}

class ArticlesReadingCollectionViewController: UICollectionViewController {

    let imageManager = PHCachingImageManager()
    
    private var articleCardModeLayout = CardMode.OverCellLayout
    private var articleCardModeOverDesign = CardMode.OverCellDesign.Dark
    private var articleCardModeSplitDesign = CardMode.SplitCellDesign.Dark

    var articleContent : [[String:AnyObject]] = [] {
        
        didSet{
            
            var newArticleContent : [[String:AnyObject]] = []
            var assets : [PHAsset] = []
            for var card in articleContent {
                let phAsset = card["midia"] as! PHAsset
                assets.append(phAsset)
                
                imageManager.requestImageForAsset(phAsset, targetSize: CGSize(width: 100,height: 100), contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image, info) in
                     card["midiaDominantColor"] = image?.dominantColors().first
                    newArticleContent.append(card)
                })
            }
            imageManager.startCachingImagesForAssets(assets, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.AspectFill, options: nil)
            
            articleContent = newArticleContent
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        // Register cell classes
        self.collectionView!.registerClass(CardContentOverCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifierOver)

        self.collectionView!.registerNib(UINib(nibName: "CardContentOverCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifierOver)
        
        
        self.collectionView!.registerClass(CardContentSplitedCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifierSplited)
        
        self.collectionView!.registerNib(UINib(nibName: "CardContentSplitedCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifierSplited)
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation:UIStatusBarAnimation.None)
        // Do any additional setup after loading the view.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    



    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleContent.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let card = articleContent[indexPath.row]
        
        switch articleCardModeLayout {
        case CardMode.OverCellLayout:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierOver, forIndexPath: indexPath) as! CardContentOverCollectionCell
            
           // cell.layer.shouldRasterize = true;
           // cell.layer.rasterizationScale = UIScreen.mainScreen().scale;
            
            cell.setContentForPreview(card, imageManager: imageManager, design: articleCardModeOverDesign.rawValue)
            
            return cell
            
        case CardMode.SplitCellLayout:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierSplited, forIndexPath: indexPath) as! CardContentSplitedCollectionCell
            
            cell.layer.shouldRasterize = true;
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale;
            
            cell.setContentForPreview(card, imageManager: imageManager, design: articleCardModeSplitDesign.rawValue)
            
            return cell
            
        }
    
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    }
    
    func changeLayout() {
        articleCardModeLayout = CardMode(rawValue: (articleCardModeLayout.rawValue + 1 ) % CardMode.count)!
        
        //reload section to change with animation
        self.collectionView?.performBatchUpdates({ 
                self.collectionView?.reloadSections(NSIndexSet(index: 0))
            }, completion: nil)
        
    }
    
    
    func changeDesign() {
        
        switch articleCardModeLayout {
        case CardMode.OverCellLayout:
         articleCardModeOverDesign = CardMode.OverCellDesign(rawValue: (articleCardModeOverDesign.rawValue + 1 ) % CardMode.OverCellDesign.count)!
            break
        case CardMode.SplitCellLayout:
            articleCardModeSplitDesign = CardMode.SplitCellDesign(rawValue: (articleCardModeSplitDesign.rawValue + 1 ) % CardMode.SplitCellDesign.count)!
            break

        }

        //reload section to change with animation
        self.collectionView?.performBatchUpdates({
            self.collectionView?.reloadSections(NSIndexSet(index: 0))
            }, completion: nil)
        
    }
    

    // MARK: UICollectionViewDelegate



}
