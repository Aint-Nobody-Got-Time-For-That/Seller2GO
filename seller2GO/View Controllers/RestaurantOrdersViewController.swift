//
//  RestaurantOrdersViewController.swift
//  seller2GO
//
//  Created by Victor Li on 11/10/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse
import SwipeCellKit
import PKHUD

class RestaurantOrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var restaurant: Restaurant!
    var orders: [Order]  = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        
        return options
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurantOrderCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantOrderCell") as! RestaurantOrderCell
        restaurantOrderCell.order = orders[indexPath.row]
        restaurantOrderCell.selectionStyle = .none
        restaurantOrderCell.delegate = self
        return restaurantOrderCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    private func displayError(_ error: Error) {
        PKHUD.sharedHUD.hide(animated: true)
        let alertController = UIAlertController(title: "Error Deleting Order", message: error.localizedDescription, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let cell = tableView.cellForRow(at: indexPath) as! RestaurantOrderCell
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            cell.hideSwipe(animated: true, completion: { (Bool) in
                let itemToDelete = self.orders[indexPath.row]
                
                let alertController = UIAlertController(title: "Deleting Item", message: "Are you sure you want to delete this order?", preferredStyle: .alert)
                
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
                            PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: "Order Deleted")
                            PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                                
                                self.orders.remove(at: indexPath.row)
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
        
        
        return [deleteAction]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "\(restaurant.name) Orders"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
        let ordersQuery = PFQuery(className: "Order")
        ordersQuery.whereKey("restaurantID", equalTo: restaurant.objectId!)
        
        ordersQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if error == nil, let orders = objects {
                
                self.orders = orders as! [Order]
                self.tableView.reloadData()
                
            } else {
                print("Error in orders query: \(error!)")
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let order = orders[indexPath.row]
            
            let orderViewController = segue.destination as! OrderViewController
            orderViewController.order = order
            orderViewController.restaurant = restaurant
        }
    }
}
