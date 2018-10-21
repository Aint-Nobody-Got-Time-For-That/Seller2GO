//
//  UserRestaurantsViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/19/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse

class UserRestaurantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nav: UINavigationItem!
    
    var restaurants: [Restaurant] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        restaurantCell.restaurant = restaurants[indexPath.row]
        return restaurantCell
    }
    
    @objc func tapLogout(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    @objc func tapEdit(_ sender: Any) {
        print("Edit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // set up nav bar
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: #selector(UserRestaurantsViewController.tapLogout(_:)))
        nav.leftBarButtonItem = logoutBarButtonItem
        
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: #selector(UserRestaurantsViewController.tapEdit(_:)))
        nav.rightBarButtonItem = editBarButtonItem
        
        let restaurantQuery = PFQuery(className: "Restaurant")
        restaurantQuery.whereKey("user", equalTo: PFUser.current()!)
        
        restaurantQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil, let userRestaurants = objects {
                self.restaurants = userRestaurants as! [Restaurant]
            } else {
                print("Error in restaurant query: \(error!)")
            }
        }
    }
}
