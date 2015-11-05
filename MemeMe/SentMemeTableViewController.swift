//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Craig Vanderzwaag on 11/3/15.
//  Copyright © 2015 blueHula Studios. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    //MARK: View Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Provide UI Guidance on initial open
        if(memes.count == 0){
            
        let alertView = UIAlertController(title: "Lets Get MEME-Y!", message: "Get started here or by touching the Add button up top!", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
            alertView.addAction(UIAlertAction(title: "Let's GO", style: .Default, handler: { (alertAction) -> Void in
                self.didTouchAddButton()
            }))
            
            presentViewController(alertView, animated: true, completion: nil)
        }
        //Remove Extra TableView Rows
        tableView.tableFooterView = UIView.init(frame: CGRectZero)
    }
    
    //MARK: TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->  UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomMemeTableViewCell
        
        if memes.count > 0 {
            
            let meme = memes[indexPath.row]
            cell.memeImageView.image = meme.memeImage
            cell.topLabel.text = meme.topString
            cell.bottomLabel.text = meme.bottomString
            
        } else {
            
            cell.topLabel.text = "No Memes Currently Stored"
            cell.bottomLabel.text = "Press + to Create!!"
        }
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if segue.identifier == "detail" {
                let detailVC:MemeDetailViewController = segue.destinationViewController as! MemeDetailViewController
                detailVC.selectedMeme = memes[indexPath.row]
                
            }
        }
    }
    
    //MARK: Actions
    func didTouchAddButton (){
        
        performSegueWithIdentifier("editMeme", sender: self)
        
    }

    @IBAction func didTouchEditButton(sender: UIBarButtonItem) {
        
        if tableView.editing == true {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
        } else  {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
        }
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}


