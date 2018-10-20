//
//  LoginViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/18/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func onTapLogin(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                self.performSegue(withIdentifier: "gotoUserRestaurantsSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onTapCreateAccount(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCreateRestaurantSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
