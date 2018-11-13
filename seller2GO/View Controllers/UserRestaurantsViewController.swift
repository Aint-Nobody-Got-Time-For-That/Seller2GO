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
import PKHUD

class UserRestaurantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nav: UINavigationItem!
    
    var restaurants: [Restaurant] = []
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let cell = tableView.cellForRow(at: indexPath) as! RestaurantCell
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            let restaurantToDelete = self.restaurants[indexPath.row]
            
            cell.hideSwipe(animated: true, completion: { (Bool) in
                let alertController = UIAlertController(title: "Delete Restaurant", message: "Are you sure you want to delete \(restaurantToDelete.name)?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    // handle cancel response here.
                    cell.hideSwipe(animated: true)
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                    
                    // show PKHUD
                    PKHUD.sharedHUD.contentView = PKHUDProgressView()
                    PKHUD.sharedHUD.show()
                    
                    let menuItemsQuery = PFQuery(className: "MenuItem")
                    menuItemsQuery.whereKey("restaurant", equalTo: restaurantToDelete)
                    menuItemsQuery.findObjectsInBackground { (items: [PFObject]?, error: Error?) in
                        if error == nil, let items = items {
                            // delete all menu items associated with this restaurant
                            PFObject.deleteAll(inBackground: items, block: { (success: Bool, error: Error?) in
                                if success {
                                    // delete restaurant
                                    restaurantToDelete.deleteInBackground(block: { (success: Bool, error: Error?) in
                                        
                                        if success {
                                            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                                            PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                                                self.restaurants.remove(at: indexPath.row)
                                                action.fulfill(with: ExpansionFulfillmentStyle.delete)
                                            })
                                        } else {
                                            print("delete user restaurant save in background error: \(error!)")
                                            self.displayError(error!)
                                        }
                                        
                                    })
                                } else {
                                    print("delete all menu items error: \(error!)")
                                    self.displayError(error!)
                                }
                            })
                        } else {
                            print("find menu items in background error: \(error!)")
                            self.displayError(error!)
                        }
                    }

                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
            
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            
            cell.hideSwipe(animated: true, completion: { (Bool) in
                let restaurantToEdit = self.restaurants[indexPath.row]
                self.performSegue(withIdentifier: "editRestaurantSegue", sender: restaurantToEdit)
            })
            
        }
        
        // customize the action appearance
        // deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        
        return options
        
    }
    
    private func displayError(_ error: Error) {
        PKHUD.sharedHUD.hide(animated: true)
        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
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
        if segue.identifier == "addRestaurantSegue" {
            // nothing to add
        } else if segue.identifier == "editRestaurantSegue" {
            let restaurant = sender as! Restaurant
            let navController = segue.destination as! UINavigationController
            let editRestaurantViewController = navController.topViewController as! EditRestaurantViewController
            editRestaurantViewController.restaurant = restaurant
        } else { // for push table view
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let restaurant = restaurants[indexPath.row]
                let tabVC = segue.destination as! UITabBarController
                
                // set values for all the view controllers contained in the tab bar controllers
                let restaurantMenuViewController = tabVC.viewControllers?.first as! RestaurantMenuViewController
                restaurantMenuViewController.restaurant = restaurant
                
                let restaurantOrdersViewController = tabVC.viewControllers?[1] as! RestaurantOrdersViewController
                restaurantOrdersViewController.restaurant = restaurant
                
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
                self.tableView.reloadData()
            } else {
                print("Error in restaurant query: \(error!)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 110
        
        // set up nav bar
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(UserRestaurantsViewController.tapLogout(_:)))
        logoutBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nav.leftBarButtonItem = logoutBarButtonItem
        
        let addBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(UserRestaurantsViewController.tapAdd(_:)))
        addBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nav.rightBarButtonItem = addBarButtonItem
        nav.title = "Your restaurants"
    }
}
