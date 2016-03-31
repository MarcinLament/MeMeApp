//
//  UIImagePickerController+SupportedOrientations.swift
//  MeMeApp
//
//  Created by Marcin Lament on 31/03/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

extension UIImagePickerController{
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
}
