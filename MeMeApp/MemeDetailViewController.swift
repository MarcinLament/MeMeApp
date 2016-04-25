//
//  MemeDetailViewController.swift
//  MeMeApp
//
//  Created by Marcin Lament on 21/04/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: MeMe!
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
        imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
}
