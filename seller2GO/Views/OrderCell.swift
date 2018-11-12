//
//  OrderCell.swift
//  seller2GO
//
//  Created by Victor Li on 11/11/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var menuItemLabel: UILabel!
    
    var orderItem: OrderItem! {
        didSet {
            let quantity = orderItem.quantity
            
            let menuItemObject = (orderItem.value(forKey: "menuItem")! as! [MenuItem])[0]
            
            let menuItemQuery = PFQuery(className: "MenuItem")
            menuItemQuery.whereKey("objectId", equalTo: menuItemObject.objectId!)
            menuItemQuery.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
                if error == nil, let object = object {
                    let menuItem = object as! MenuItem
                    self.menuItemLabel.text = "\(quantity) x \(menuItem.name)"
                } else {
                    print("Error in get first menu item query: \(error!)")
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
