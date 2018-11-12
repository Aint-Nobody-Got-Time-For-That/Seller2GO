//
//  OrderViewController.swift
//  seller2GO
//
//  Created by Victor Li on 11/11/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse

class OrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var order: Order!
    var orderItems: [OrderItem] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        orderCell.orderItem = orderItems[indexPath.row]
        return orderCell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let orderItemsQuery = PFQuery(className: "OrderItem")
        orderItemsQuery.whereKey("order", equalTo: order!)
        
        orderItemsQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil, let objects = objects {
                self.orderItems = objects as! [OrderItem]
                self.tableView.reloadData()
            } else {
                print("Error in orderItems query: \(error!)")
            }
        }
        // print(orderItems)
        // get order items
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

}
