//
//  ViewController.swift
//  MeMeApp
//
//  Created by Marcin Lament on 20/02/2016.
//  Copyright © 2016 Marcin Lament. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        setTextFieldProperties(topTextField, attributes: memeTextAttributes, tag: 0)
        setTextFieldProperties(bottomTextField, attributes: memeTextAttributes, tag: 1)
    }
    
    func setTextFieldProperties(textField: UITextField, attributes: [String: AnyObject], tag: Int){
        textField.defaultTextAttributes = attributes
        textField.textAlignment = .Center
        textField.delegate = modifyTextDelegate
        textField.tag = tag
    }
    
    @IBAction func closeEditor(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        //Create the meme
        meme = MeMe( topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:
            imageView.image!, memedImage: generateMemedImage())
        
        let activityItem: [AnyObject] = [meme.memedImage as AnyObject]
        activityViewController = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            activityViewController.popoverPresentationController?.barButtonItem = shareButton
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)

        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
                return
            }
        }
    }
    
    func resetViews(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false;
    }
    
    @IBAction func resetViews(sender: AnyObject) {
        imageView.image = nil
        resetViews()
    }
    
    @IBAction func pickImage(sender: AnyObject) {
        presentImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        presentImagePicker(UIImagePickerControllerSourceType.Camera)
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
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
        if(bottomTextField.editing){
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if(bottomTextField.editing){
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
        let helper = MRPhotosHelper()
        
        // save the image to library
        helper.saveImageAsAsset(meme.memedImage, completion: { (localIdentifier) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if(localIdentifier != nil){
                    self.meme.imageLocalIdentifier = localIdentifier;
                    
                    //add saved meme to the collection
                    let object = UIApplication.sharedApplication().delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.addNewMeme(self.meme)

                    self.showAlert("Saved!", message: "Your altered image has been saved to your photos.", completion: { (action: UIAlertAction) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    
                }else{
                    self.showAlert("Save error", message: "Problem saving the image", completion: nil)
                }
                
                self.activityViewController.dismissViewControllerAnimated(true, completion: nil)
            })

        })
    }
    
    func generateMemedImage() -> UIImage{
        navigationController?.navigationBar.hidden = true
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationController?.navigationBar.hidden = false
        toolbar.hidden = false
        
        return memedImage
    }
}

