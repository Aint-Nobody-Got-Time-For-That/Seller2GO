//
//  MenuItemCell.swift
//  seller2GO
//
//  Created by Victor Li on 10/20/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse
import SwipeCellKit

class MenuItemCell: SwipeTableViewCell {

    @IBOutlet weak var menuItemImageView: PFImageView!
    @IBOutlet weak var menuItemNameLabel: UILabel!
    @IBOutlet weak var menuItemPriceLabel: UILabel!
    @IBOutlet weak var menuItemDescriptionLabel: UILabel!
    
    var menuItem: MenuItem! {
        didSet {
            menuItemImageView.file = menuItem.photo
            menuItemImageView.loadInBackground()
            
            menuItemNameLabel.text = menuItem.name
            menuItemPriceLabel.text = "$\(menuItem.price)"
            menuItemDescriptionLabel.text = menuItem.menuItemDescription
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        menuItemImageView.layer.cornerRadius = 3
        menuItemImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
