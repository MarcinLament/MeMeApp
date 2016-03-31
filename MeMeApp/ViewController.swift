//
//  ViewController.swift
//  MeMeApp
//
//  Created by Marcin Lament on 20/02/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let modifyTextDelegate = ModifyTextDelegate()
    var meme: MeMe!
    var activityViewController: UIActivityViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextProperties()
        resetViews()
        shareButton.enabled = false;
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotification()
    }
    
    func setTextProperties(){
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
            NSStrokeWidthAttributeName : -4
        ]
        
        setTextFieldProperties(self.topTextField, attributes: memeTextAttributes, tag: 0)
        setTextFieldProperties(self.bottomTextField, attributes: memeTextAttributes, tag: 1)
    }
    
    func setTextFieldProperties(textField: UITextField, attributes: [String: AnyObject], tag: Int){
        textField.defaultTextAttributes = attributes
        textField.textAlignment = .Center
        textField.delegate = modifyTextDelegate
        textField.tag = tag
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        //Create the meme
        self.meme = MeMe( topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:
            imageView.image!, memedImage: generateMemedImage())
        
        let activityItem: [AnyObject] = [self.meme.memedImage as AnyObject]
        self.activityViewController = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        self.presentViewController(self.activityViewController, animated: true, completion: nil)

        self.activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
                return
            }
        }
    }
    
    func resetViews(){
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        shareButton.enabled = false;
    }
    
    @IBAction func resetViews(sender: AnyObject) {
        imageView.image = nil
        resetViews()
    }
    
    @IBAction func pickImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        UIInterfaceOrientationMask.All
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image;
            shareButton.enabled = true
        }
    }
    
    func keyboardWillShow(notification: NSNotification){
        if(self.bottomTextField.editing){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if(self.bottomTextField.editing){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
    }
    
    func save() {
        UIImageWriteToSavedPhotosAlbum(meme.memedImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
        self.activityViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage{
        self.navigationController?.navigationBar.hidden = true
        self.toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBar.hidden = false
        self.toolbar.hidden = false
        
        return memedImage
    }
}

