//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Craig Vanderzwaag on 11/3/15.
//  Copyright © 2015 blueHula Studios. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var detailMemeImage : UIImage!
    var selectedMeme : Meme!
    
    @IBOutlet weak var detailMemeImageView: UIImageView!
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: Selector("openMemeEditor"))
        self.navigationItem.rightBarButtonItem = editButton
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        detailMemeImageView.image = selectedMeme.memeImage
    }
    
    func openMemeEditor() {
        
        performSegueWithIdentifier("editMeme", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let detailVC:MemeEditorViewController = segue.destinationViewController as! MemeEditorViewController
        detailVC.topText = selectedMeme.topString;
        detailVC.bottomText = selectedMeme.bottomString
        detailVC.image = selectedMeme.originalImage
    
    }
}


