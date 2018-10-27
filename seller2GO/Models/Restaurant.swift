//
//  Restaurant.swift
//  seller2GO
//
//  Created by Victor Li on 10/18/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import Foundation
import Parse

class Restaurant: PFObject, PFSubclassing {
    @NSManaged var photo: PFFile
    @NSManaged var name: String
    @NSManaged var phoneNumber: String
    @NSManaged var street: String
    @NSManaged var city: String
    @NSManaged var state: String
    @NSManaged var zipCode: String
    
    static func parseClassName() -> String {
        return "Restaurant"
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
            let resizedImage = resize(image: image, newSize: CGSize(width: 300, height: 300))
            if let imageData = UIImagePNGRepresentation(resizedImage) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    class func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
