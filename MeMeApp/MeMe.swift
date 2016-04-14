//
//  MeMe.swift
//  MeMeApp
//
//  Created by Marcin Lament on 23/03/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

class MeMe: NSObject, NSCoding{
    
    var topText: NSString
    var bottomText: NSString
    var originalImage: UIImage!
    var memedImage: UIImage!
    var imageLocalIdentifier: String!
    
    init(topText: NSString, bottomText: NSString, originalImage: UIImage, memedImage: UIImage){
        self.topText = topText;
        self.bottomText = bottomText;
        self.originalImage = originalImage;
        self.memedImage = memedImage;
    }
    
    required init(coder aDecoder: NSCoder) {
        topText = aDecoder.decodeObjectForKey("topText") as! String
        bottomText = aDecoder.decodeObjectForKey("bottomText") as! String
        imageLocalIdentifier = aDecoder.decodeObjectForKey("imageLocalIdentifier") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(topText, forKey: "topText")
        aCoder.encodeObject(bottomText, forKey: "bottomText")
        
        if(imageLocalIdentifier != nil){
            aCoder.encodeObject(imageLocalIdentifier, forKey: "imageLocalIdentifier")
        }
    }
}