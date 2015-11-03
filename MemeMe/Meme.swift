//
//  Meme.swift
//  MemeMe
//
//  Created by Craig Vanderzwaag on 11/2/15.
//  Copyright © 2015 blueHula Studios. All rights reserved.
//

import UIKit

class Meme: NSObject{
    var topString: String!
    var bottomString: String!
    var originalImage: UIImage!
    var memeImage: UIImage!
    
    init(topString: String!, bottomString: String!, originalImage: UIImage!, memeImage: UIImage!) {
        self.topString = topString
        self.bottomString = bottomString
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
    
}