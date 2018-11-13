//
//  RestaurantOrdersViewController.swift
//  seller2GO
//
//  Created by Victor Li on 11/10/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse

class RestaurantOrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var restaurant: Restaurant!
    var orders: [Order]  = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurantOrderCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantOrderCell") as! RestaurantOrderCell
        restaurantOrderCell.order = orders[indexPath.row]
        return restaurantOrderCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
