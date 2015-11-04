//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Craig Vanderzwaag on 11/1/15.
//  Copyright © 2015 blueHula Studios. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextInput: UITextField!
    @IBOutlet weak var bottomTextInput: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memedImage: UIImage!
    
    var topText: String!
    var bottomText: String!
    var image: UIImage!
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Establish TextField Text Attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 32)!,
            NSStrokeWidthAttributeName : -5.0]
        
        //Configure TextFields
     
        topTextInput.defaultTextAttributes = memeTextAttributes
        topTextInput.backgroundColor = UIColor.clearColor()
        topTextInput.textAlignment = .Center
        
        
        bottomTextInput.defaultTextAttributes = memeTextAttributes
        bottomTextInput.backgroundColor = UIColor.clearColor()
        bottomTextInput.textAlignment = .Center
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Listen for keyboard presentation notifications
        subscribeToKeyboardNotifications()
        
        //Check if the device camera is available, if so enable camera button
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //If editing selected meme instead of creating a new meme, load exisiting content
        if((topText) != nil){
            topTextInput.text = topText
            bottomTextInput.text = bottomText
            imagePickerView.image = image
            shareButton.enabled = true
            }
        }
    
    override func viewWillDisappear(animated: Bool) {
        //Stop listening for keyboard presentation notifications
        unsubscribeToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    //MARK: Keyboard Handling Methods
    
    func keyboardWillShow(notification: NSNotification) {
        
        //Get keyboard heigth and set view origin y value
        if bottomTextInput.isFirstResponder() {
            view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        //Move view back to bottom when keyboard is dismissed
        if bottomTextInput.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight (notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return keyboardSize.CGRectValue().height
        
    }

    func subscribeToKeyboardNotifications () {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications () {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: Media Selection Methods
    
    @IBAction func selectImageFromCameraRoll(sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController ()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera (sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    //MARK:  Create/Share/Save MEME Methods
    
    func generateMemedImage() -> UIImage {
        
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navBar.hidden = false
        toolBar.hidden = false

        return memedImage
        
    }
    
    func saveMeme() {
        
        // Create the meme
        let meme = Meme (topString: topTextInput.text, bottomString: bottomTextInput.text, originalImage: imagePickerView.image, memeImage:memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    @IBAction func didTouchShareButton(sender: UIBarButtonItem) {
        
        memedImage = generateMemedImage()
        
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
            presentViewController(vc, animated: true, completion: nil)
            vc.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func didTouchCancelButton(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
 
    
    //MARK: TextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = nil
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

