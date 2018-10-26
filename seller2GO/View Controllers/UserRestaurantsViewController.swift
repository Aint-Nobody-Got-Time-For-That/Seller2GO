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
            
            let restaurantToDelete = self.restaurants[indexPath.row]
            
            let alertController = UIAlertController(title: "Delete Restaurant", message: "Are you sure you want to delete \(restaurantToDelete.name)?", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            // add the cancel action to the alertController
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
                // show PKHUD
                PKHUD.sharedHUD.contentView = PKHUDProgressView()
                PKHUD.sharedHUD.show()
                
                restaurantToDelete.deleteInBackground(block: { (success: Bool, error: Error?) in
                    
                    if success {
                        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                        PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                            
                            self.restaurants.remove(at: indexPath.row)
                            
                        })
                    } else {
                        print("delete user restaurant save in background error: \(error!)")
                        self.displayError(error!)
                    }
                    
                })
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            print("Edit")
        }
        
        // customize the action appearance
        // deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction, editAction]
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
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(UserRestaurantsViewController.tapLogout(_:)))
        nav.leftBarButtonItem = logoutBarButtonItem
        
        let addBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(UserRestaurantsViewController.tapAdd(_:)))
        nav.rightBarButtonItem = addBarButtonItem
        nav.title = "Your restaurants"
    }
}
