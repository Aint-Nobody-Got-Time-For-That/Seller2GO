//
//  OrdersViewController.swift
//  seller2GO
//
//  Created by Victor Li on 11/10/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse

class OrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var restaurantId: String!
    var orders: [Order]  = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        orderCell.order = orders[indexPath.row]
        return orderCell
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
        ordersQuery.whereKey("restaurantID", equalTo: restaurantId!)
        
        ordersQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            
            if error == nil, let orders = objects {
                
                self.orders = orders as! [Order]
                self.tableView.reloadData()
                
            } else {
                print("Error in orders query: \(error!)")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
