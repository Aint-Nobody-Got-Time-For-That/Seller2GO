//
//  RestaurantCell.swift
//  seller2GO
//
//  Created by Victor Li on 10/20/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse
import SwipeCellKit

class RestaurantCell: SwipeTableViewCell {

    @IBOutlet weak var restaurantImageView: PFImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantPhoneNumberLabel: UILabel!
    
    var restaurant: Restaurant! {
        didSet {
            restaurantImageView.file = restaurant.photo
            restaurantImageView.loadInBackground()
            
            restaurantAddress.text = "\(restaurant.street), \(restaurant.city), \(restaurant.state) \(restaurant.zipCode)"
            restaurantNameLabel.text = restaurant.name
            restaurantPhoneNumberLabel.text = restaurant.phoneNumber
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        restaurantImageView.layer.cornerRadius = 3
        restaurantImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
