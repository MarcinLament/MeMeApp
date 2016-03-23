//
//  ModifyTextDelegate.swift
//  MeMeApp
//
//  Created by Marcin Lament on 23/03/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import Foundation
import UIKit

class ModifyTextDelegate: NSObject, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if((textField.tag == 0 && textField.text == "TOP") || (textField.tag == 1 && textField.text == "BOTTOM")){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true;
    }
}
