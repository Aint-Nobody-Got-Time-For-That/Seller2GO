//
//  OrderViewController.swift
//  seller2GO
//
//  Created by Victor Li on 11/11/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse

class OrderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var order: Order!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(order)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

}
