//
//  RestaurantMenuViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/20/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse
import SwipeCellKit
import PKHUD

class RestaurantMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {

    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var restaurant: Restaurant!
    var menuItems: [MenuItem] = []
    
    @objc func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapAdd(_ sender: Any) {
        performSegue(withIdentifier: "addToMenuSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItemCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as! MenuItemCell
        menuItemCell.delegate = self
        menuItemCell.selectionStyle = .none
        menuItemCell.menuItem = menuItems[indexPath.row]
        return menuItemCell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let cell = tableView.cellForRow(at: indexPath) as! MenuItemCell
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            cell.hideSwipe(animated: true, completion: { (Bool) in
                let itemToDelete = self.menuItems[indexPath.row]
                
                let alertController = UIAlertController(title: "Deleting Item", message: "Are you sure you want to delete \(itemToDelete.name)?", preferredStyle: .alert)
                
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
                    
                    itemToDelete.deleteInBackground(block: { (success: Bool, error: Error?) in
                        
                        if success {
                            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                            PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                                
                                self.menuItems.remove(at: indexPath.row)
                                action.fulfill(with: ExpansionFulfillmentStyle.delete)
                            })
                        } else {
                            print("delete menu item save in background error: \(error!)")
                            self.displayError(error!)
                        }
                        
                    })
                    
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        deleteAction.image = UIImage(named: "Trash Icon")
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            
            cell.hideSwipe(animated: true, completion: { (Bool) in
                let itemToEdit = self.menuItems[indexPath.row]
                self.performSegue(withIdentifier: "editMenuItemSegue", sender: itemToEdit)
            })
            
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        editAction.image = UIImage(named: "iconmonstr-pencil")
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        
        if segue.identifier == "editMenuItemSegue" {
            let editMenuItemViewController = navController.viewControllers.first as! EditMenuItemViewController
            let menuItem = sender as! MenuItem
            editMenuItemViewController.menuItem = menuItem
        } else if segue.identifier == "addToMenuSegue" {
            let addToMenuViewController = navController.viewControllers.first as! AddToMenuViewController
            addToMenuViewController.restaurant = restaurant
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // get menu items
        let menuItemQuery = PFQuery(className: "MenuItem")
        menuItemQuery.whereKey("restaurant", equalTo: restaurant)
        
        menuItemQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil, let items = objects {
                self.menuItems = items as! [MenuItem]
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
        
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-icon"), style: .plain, target: self, action: #selector(RestaurantMenuViewController.tapBack(_:)))
        backBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        self.tabBarController?.title = "\(restaurant.name)'s Menu"
        let addBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(RestaurantMenuViewController.tapAdd(_:)))
        addBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.tabBarController?.title = "\(restaurant.name)'s Menu"
        self.tabBarController?.navigationItem.leftBarButtonItem = backBarButtonItem
        self.tabBarController?.navigationItem.rightBarButtonItem = addBarButtonItem
    }
}
