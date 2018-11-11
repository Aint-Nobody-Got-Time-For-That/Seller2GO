//
//  Order.swift
//  seller2GO
//
//  Created by Victor Li on 11/10/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import Foundation
import Parse

class Order: PFObject, PFSubclassing {
    @NSManaged var phoneNumber: String
    @NSManaged var restaurantID: String
    @NSManaged var time: Date
    @NSManaged var total: Double
    @NSManaged var buyerName: String
    
    static func parseClassName() -> String {
        return "Order"
    }
}
