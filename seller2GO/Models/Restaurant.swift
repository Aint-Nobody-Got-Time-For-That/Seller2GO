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
    @NSManaged var hours: String
    @NSManaged var phoneNumber: String
    @NSManaged var ownerEmail: String
    
    static func parseClassName() -> String {
        return "Restaurant"
    }
    
    class func createRestaurant(image: UIImage?, name: String, hours: String, phoneNumber: String, email: String, withCompletion completion: PFBooleanResultBlock?) {
        
        let restaruant = Restaurant()
        restaruant.photo = getPFFileFromImage(image)!
        restaruant.name = name
        restaruant.hours = hours
        restaruant.phoneNumber = phoneNumber
        restaruant.ownerEmail = email
        
        restaruant.saveInBackground(block: completion)
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
