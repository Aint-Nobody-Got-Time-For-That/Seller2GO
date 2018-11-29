//
//  RestaurantOrderCell.swift
//  seller2GO
//
//  Created by Victor Li on 11/10/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import SwipeCellKit

class RestaurantOrderCell: SwipeTableViewCell {

    @IBOutlet weak var buyerLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var order: Order! {
        didSet {
            buyerLabel.text = order.buyerName
            phoneNumberLabel.text = order.phoneNumber
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
