//
//  MemeTableViewController.swift
//  MeMeApp
//
//  Created by Marcin Lament on 07/04/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [MeMe] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    let helper = MRPhotosHelper()
    
    
    // MARK: Table View Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MeMeCell")!
        let meme = self.memes[indexPath.row]
        
        if(meme.memedImage == nil){
            meme.memedImage = UIImage(named: "Placeholder")
            print("Load image " + String(indexPath.row));
            helper.retrieveImageWithIdentifer(meme, completion: { (meme) -> Void in
               print("Loaded image, refresh data");
               dispatch_async(dispatch_get_main_queue(), { () -> Void in
                   self.tableView.reloadData()
               })
            })
        }
        
        // Set the name and image
        cell.textLabel?.text = (meme.topText as String) + "..." + (meme.bottomText as String);
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
//        detailController.villain = self.allVillains[indexPath.row]
//        self.navigationController!.pushViewController(detailController, animated: true)
    }
}