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
    @IBOutlet weak var nav: UINavigationItem!

    var order: Order!
    var restaurant: Restaurant!
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
    
    @objc func tapRemove(_ sender: Any) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let deleteTheseItems: [PFObject] = [order!] + orderItems
        PFObject.deleteAll(inBackground: deleteTheseItems) { (success: Bool, error: Error?) in
            
            if success {
                
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                print("delete order and order items in background error: \(error!)")
            }
        }
    }
    
    @objc func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        orderCell.orderItem = orderItems[indexPath.row]
        orderCell.selectionStyle = .none
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
        // text buyer
        PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: "Messaged!")
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
        })
        
        let twilioNumber = Keys.TWILIONUMBER
        let message = "Your Order from \(self.restaurant!.name) is Ready! The Address is: \(self.restaurant!.street)"
        let buyerNumber = self.order.phoneNumber
        self.sendMessage(twilioNumber: twilioNumber, buyerPhoneNumber: buyerNumber, message: message)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-icon"), style: .plain, target: self, action: #selector(OrderViewController.tapBack(_:)))
        backBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nav.leftBarButtonItem = backBarButtonItem
        
        let removeBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(OrderViewController.tapRemove(_:)))
        removeBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nav.rightBarButtonItem = removeBarButtonItem
        
        nav.title = "\(order.buyerName)'s Order"
    }

}
