//
//  UserRestaurantsViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/19/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse
import SwipeCellKit

class UserRestaurantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nav: UINavigationItem!
    
    var restaurants: [Restaurant] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("delete")
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            print("Edit")
        }
        
        // customize the action appearance
        // deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as! RestaurantCell
        restaurantCell.delegate = self
        restaurantCell.selectionStyle = .none
        restaurantCell.restaurant = restaurants[indexPath.row]
        return restaurantCell
    }
    
    @objc func tapLogout(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    @objc func tapAdd(_ sender: Any) {
        performSegue(withIdentifier: "addRestaurantSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "addRestaurantSegue" {
            
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let restaurant = restaurants[indexPath.row]
                let restaurantMenuViewController = segue.destination as! RestaurantMenuViewController
                restaurantMenuViewController.restaurant = restaurant
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // set up nav bar
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: #selector(UserRestaurantsViewController.tapLogout(_:)))
        nav.leftBarButtonItem = logoutBarButtonItem
        
        let addBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: nil, action: #selector(UserRestaurantsViewController.tapAdd(_:)))
        nav.rightBarButtonItem = addBarButtonItem
    }
}
