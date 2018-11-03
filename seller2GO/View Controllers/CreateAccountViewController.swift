//
//  CreateAccountViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/26/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import Parse
import PKHUD

class CreateAccountViewController: FormViewController {

    @IBOutlet weak var nav: UINavigationItem!
    var createBarButtonItem: UIBarButtonItem!
    
    // all form validation
    var emailField = false
    var passwordField = false
    
    private func initializeForm() {
        form
            +++ Section("Login Info")
            <<< EmailRow() {
                $0.tag = "userEmail"
                $0.title = "Email"
                $0.placeholder = "JohnSmith@gmail.com"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onChange({ (row) in
                    if let value = row.value, value.count >= 4 {
                        self.emailField = true
                    } else {
                        self.emailField = false
                    }
                    
                    if self.isFormValidated() {
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
                    }
                })
            <<< PasswordRow() {
                $0.tag = "userPassword"
                $0.title = "Password"
                $0.placeholder = "···"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleGreaterOrEqualThan(min: "3"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onChange({ (row) in
                    if let value = row.value, value.count >= 3 {
                        self.passwordField = true
                    } else {
                        self.passwordField = false
                    }
                    
                    if self.isFormValidated() {
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
                    }
                })
    }
    
    // for enabling the Create Bar button
    // return true to skip form validation
    private func isFormValidated() -> Bool {
        let valuesDictionary = form.values()
        return valuesDictionary["userEmail"]! != nil && valuesDictionary["userPassword"]! != nil && emailField && passwordField
    }
    
    private func getFormValues() -> (email: String, password: String) {
        let valuesDictionary = form.values()
        let email = (valuesDictionary["userEmail"] as! String)
        let password = (valuesDictionary["userPassword"] as! String)
        
        return (email: email, password: password)
    }
    
    private func displayError(_ error: Error) {
        PKHUD.sharedHUD.hide(animated: true)
        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
    }
    
    @objc func tapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapCreate(_ sender: Any) {
        let (email, password) = getFormValues()
        
        let newUser = PFUser()
        newUser.username = email
        newUser.password = password
        
        // show PKHUD
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                    self.performSegue(withIdentifier: "goToUserRestaurantsSegue", sender: nil)
                })
            } else {
                print("New User Sign Up Error: \(error!)")
                self.displayError(error!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up nav bar
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CreateAccountViewController.tapCancel(_:)))
        cancelBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nav.leftBarButtonItem = cancelBarButtonItem
        
        createBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(CreateAccountViewController.tapCreate(_:)))
        createBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        createBarButtonItem.isEnabled = false
        nav.rightBarButtonItem = createBarButtonItem
        nav.title = "New Account"
        
        // Enables the navigation accessory and stops navigation when a disabled row is encountered
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // Enables smooth scrolling on navigation to off-screen rows
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
        
        initializeForm()
    }
    

}
