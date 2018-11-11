//
//  OrderItem.swift
//  seller2GO
//
//  Created by Victor Li on 11/10/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import Foundation
import Parse

class OrderItem: PFObject, PFSubclassing {
    @NSManaged var quantity: Int
    
    static func parseClassName() -> String {
        return "OrderItem"
    }
}
