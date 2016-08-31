//
//  ArticleCreationViewController.swift
//  Blicup
//
//  Created by Moymer on 30/08/16.
//  Copyright © 2016 Moymer. All rights reserved.
//

import UIKit
import Photos


class ArticleCreationViewController: UIViewController, UICollectionViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let presenter = ArticleCreationPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startObservingKeyboardEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidLayoutSubviews() {
        if let articleFlowLayout = collectionView.collectionViewLayout as? ArticleCreationCollectionViewFlowLayout {
            let verticalInsets = (collectionView.bounds.height - 330)/2
            articleFlowLayout.sectionInset = UIEdgeInsetsMake(verticalInsets, 20, verticalInsets, 20)
            let cellWidth = collectionView.bounds.width - (articleFlowLayout.sectionInset.left + articleFlowLayout.sectionInset.right)
            articleFlowLayout.estimatedItemSize = CGSizeMake(cellWidth, 330)
        }
        
        super.viewDidLayoutSubviews()
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfMedias()
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = indexPath.row==0 ? "CoverCell" : "ContentCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CoverCollectionViewCell
    
        let container = cell.viewWithTag(1)!
        container.layer.cornerRadius = 20
        
        cell.layer.shadowColor = UIColor.lightGrayColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(2, 2)
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 3.0
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        
        presenter.getImageMedia(indexPath) { (image) in
            cell.cardMedia.image = image
        }
        
        return cell
    }
    
    // TextView Delegate
    private func centerTextViewCell(textView:UITextView) {
        let point = collectionView.convertPoint(CGPointZero, fromView: textView)
        guard let index = collectionView.indexPathForItemAtPoint(point) else {
            return
        }
        collectionView.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
    }
    
    func textViewDidChange(textView: UITextView) {
        textView.invalidateIntrinsicContentSize()
        self.collectionView.collectionViewLayout.invalidateLayout()
        centerTextViewCell(textView)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        centerTextViewCell(textView)
    }
    
    // MARK: Keyboard
    private func startObservingKeyboardEvents() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(self.keyboardWillShow(_:)),
                                                         name:UIKeyboardWillShowNotification,
                                                         object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector:#selector(self.keyboardWillHide(_:)),
                                                         name:UIKeyboardWillHideNotification,
                                                         object:nil)
        
    }
    
    private func stopObservingKeyboardEvents() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size else {
            return
        }
        
        var inset = collectionView.contentInset
        inset.bottom = keyboardSize.height
        collectionView.contentInset = inset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        collectionView.contentInset = UIEdgeInsetsZero
    }
}