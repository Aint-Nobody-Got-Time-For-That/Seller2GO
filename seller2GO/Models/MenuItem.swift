//
//  MenuItem.swift
//  seller2GO
//
//  Created by Victor Li on 10/19/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import Foundation
import Parse

class MenuItem: PFObject, PFSubclassing {
    
    @NSManaged var photo: PFFile
    @NSManaged var menuItemDescription: String
    @NSManaged var price: Double
    @NSManaged var name: String
    
    static func parseClassName() -> String {
        return "MenuItem"
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(_ image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
