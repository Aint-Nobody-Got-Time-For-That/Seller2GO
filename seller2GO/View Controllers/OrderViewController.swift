//
//  OrderViewController.swift
//  seller2GO
//
//  Created by Victor Li on 11/11/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import PKHUD

class OrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var order: Order!
    var restaurantName: String!
    var orderItems: [OrderItem] = []
    
    func sendMessage(twilioNumber: String, buyerPhoneNumber: String, message: String) {
        let accountSID = Keys.TWILIOSID
        let authToken = Keys.TWILIOAUTH
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        let parameters = ["From": twilioNumber, "To": buyerPhoneNumber, "Body": message]
        
        Alamofire.request(url, method: .post, parameters: parameters)
            .authenticate(user: accountSID, password: authToken)
            .responseJSON { response in
                debugPrint(response)
        }
    }
    
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
        
        // get order items
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
        
    }

    @IBAction func didTapReady(_ sender: Any) {
        let twilioNumber = Keys.TWILIONUMBER
        let message = "Your Order from \(self.restaurantName!) is Ready!"
        let buyerNumber = self.order.phoneNumber
        self.sendMessage(twilioNumber: twilioNumber,  buyerPhoneNumber: buyerNumber, message: message)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

}
