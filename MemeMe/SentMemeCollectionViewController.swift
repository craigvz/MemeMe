//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Craig Vanderzwaag on 11/3/15.
//  Copyright © 2015 blueHula Studios. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.reloadData()
    }
    
    
    //MARK: CollectionView
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.memeImageView.image = meme.memeImage
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "collectionDetail" {
                if let indexPath = collectionView?.indexPathForCell(sender as! CustomMemeCollectionViewCell) {
                let detailVC:MemeDetailViewController = segue.destinationViewController as! MemeDetailViewController
                detailVC.selectedMeme = memes[indexPath.row]
                
            }
        }
    }

}
