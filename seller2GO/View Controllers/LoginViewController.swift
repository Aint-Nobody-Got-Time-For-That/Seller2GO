//
//  LoginViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/18/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func onTapLogin(_ sender: Any) {
        print("tapping login button")
    }
    
    @IBAction func onTapCreateAccount(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCreateRestaurantSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createRestaurantViewController = segue.destination as! CreateRestaurantViewController
        createRestaurantViewController.email = emailTextField.text!
        createRestaurantViewController.password = passwordTextField.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
