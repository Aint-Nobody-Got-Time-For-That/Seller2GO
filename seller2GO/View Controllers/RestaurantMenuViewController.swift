//
//  RestaurantMenuViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/20/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse

class RestaurantMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var restaurant: Restaurant!
    var menuItems: [MenuItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @objc func tapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapAdd(_ sender: Any) {
        print("Edit Menu Item")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItemCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as! MenuItemCell
        menuItemCell.menuItem = menuItems[indexPath.row]
        return menuItemCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(RestaurantMenuViewController.tapBack(_:)))
        nav.leftBarButtonItem = backBarButtonItem
        
        let addBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: nil, action: #selector(RestaurantMenuViewController.tapAdd(_:)))
        nav.rightBarButtonItem = addBarButtonItem

        // title of nav
        nav.title = "\(restaurant.name)'s Menu"
        
        // get menu items
        let menuItemQuery = PFQuery(className: "MenuItem")
        menuItemQuery.whereKey("restaurant", equalTo: restaurant)
        
        menuItemQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil, let items = objects {
                self.menuItems = items as! [MenuItem]
            } else {
                print("Error in restaurant query: \(error!)")
            }
        }
    }
}
