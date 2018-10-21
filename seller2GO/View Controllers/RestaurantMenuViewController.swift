//
//  RestaurantMenuViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/20/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit

class RestaurantMenuViewController: UIViewController {

    @IBOutlet weak var nav: UINavigationItem!
    
    @objc func tapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(RestaurantMenuViewController.tapBack(_:)))
        nav.leftBarButtonItem = backBarButtonItem

        // Do any additional setup after loading the view.
    }
}
