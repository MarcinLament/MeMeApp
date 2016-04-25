//
//  MemeCollectionViewController.swift
//  MeMeApp
//
//  Created by Marcin Lament on 21/04/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    var memes: [MeMe] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    let helper = MRPhotosHelper()
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 5.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        setFlowLayoutSize(space, dimension: dimension)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let space: CGFloat = 5.0
        let dimension = (size.width - (2 * space)) / 3.0
        
        setFlowLayoutSize(space, dimension: dimension)
    }
    
    func setFlowLayoutSize(space: CGFloat, dimension: CGFloat){
        if(flowLayout != nil){
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSizeMake(dimension, dimension)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MeMeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.row]
        
        if(meme.memedImage == nil){
            meme.memedImage = UIImage(named: "Placeholder")
            helper.retrieveImageWithIdentifer(meme, completion: { (meme) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView!.reloadData()
                })
            })
        }
        
        cell.memeImageView.image = meme.memedImage
        
        return cell

    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MeMeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
        
    }

}
