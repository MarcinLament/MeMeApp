//
//  MeMe.swift
//  MeMeApp
//
//  Created by Marcin Lament on 23/03/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

struct MeMe{
    
    var topText: NSString
    var bottomText: NSString
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: NSString, bottomText: NSString, originalImage: UIImage, memedImage: UIImage){
        self.topText = topText;
        self.bottomText = bottomText;
        self.originalImage = originalImage;
        self.memedImage = memedImage;
    }
}