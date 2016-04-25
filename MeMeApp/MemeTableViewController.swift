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
    
    @IBAction func editItems(sender: UIBarButtonItem) {
        if(editing){
            sender.title = "Cancel"
        }else{
            sender.title = "Edit"
        }
        editing = !editing
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MeMeCell")!
        let meme = memes[indexPath.row]
        
        if(meme.memedImage == nil){
            meme.memedImage = UIImage(named: "Placeholder")
            helper.retrieveImageWithIdentifer(meme, completion: { (meme) -> Void in
               dispatch_async(dispatch_get_main_queue(), { () -> Void in
                   tableView.reloadData()
               })
            })
        }
        
        cell.textLabel?.text = (meme.topText as String) + "..." + (meme.bottomText as String)
        cell.imageView?.image = meme.memedImage
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MeMeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //For deleting the Meme
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle:   UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).removeMeme(indexPath.row)
        tableView.reloadData()
    }
}