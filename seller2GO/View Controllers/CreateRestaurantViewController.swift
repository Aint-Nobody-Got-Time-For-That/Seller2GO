//
//  CreateRestaurantViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/18/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Eureka
import ImageRow

class CreateRestaurantViewController: FormViewController {
    
    @IBOutlet weak var nav: UINavigationItem!
    var nextBarButtonItem: UIBarButtonItem!
    
    // all form validated
    var emailField = false
    var passwordField = false
    var restaurantNameField = false
    var restaurantStreetField = false
    var restaurantCityField = false
    var restaurantPhoneNumberField = false
    var restaurantZipCodeField = false
    
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
                        self.nextBarButtonItem.isEnabled = true
                    } else {
                        self.nextBarButtonItem.isEnabled = false
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
                        self.nextBarButtonItem.isEnabled = true
                    } else {
                        self.nextBarButtonItem.isEnabled = false
                    }
                })
            
            +++ Section("Restaurant Info")
            <<< NameRow() {
                $0.tag = "restaurantName"
                $0.title = "Name"
                $0.placeholder = "Starbucks"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleGreaterOrEqualThan(min: "1"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onChange({ (row) in
                    if let value = row.value, value.count >= 1 {
                        self.restaurantNameField = true
                    } else {
                        self.restaurantNameField = false
                    }
                    
                    if self.isFormValidated() {
                        self.nextBarButtonItem.isEnabled = true
                    } else {
                        self.nextBarButtonItem.isEnabled = false
                    }
                })
            <<< ImageRow() {
                $0.tag = "restaurantImage"
                $0.title = "Photo"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.value = UIImage(named: "iconmonstr-eat")
                $0.clearAction = .no
            }
            <<< TextRow() {
                $0.tag = "restaurantStreet"
                $0.title = "Street"
                $0.placeholder = "123 Jane Street"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleGreaterOrEqualThan(min: "1"))
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onChange({ (row) in
                    if let value = row.value, value.count >= 1 {
                        self.restaurantStreetField = true
                    } else {
                        self.restaurantStreetField = false
                    }
                    
                    if self.isFormValidated() {
                        self.nextBarButtonItem.isEnabled = true
                    } else {
                        self.nextBarButtonItem.isEnabled = false
                    }
                })
            <<< TextRow() {
                $0.tag = "restaurantCity"
                $0.title = "City"
                $0.placeholder = "San Francisco"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleGreaterOrEqualThan(min: "1"))
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onChange({ (row) in
                    if let value = row.value, value.count >= 1 {
                        self.restaurantCityField = true
                    } else {
                        self.restaurantCityField = false
                    }
                    
                    if self.isFormValidated() {
                        self.nextBarButtonItem.isEnabled = true
                    } else {
                        self.nextBarButtonItem.isEnabled = false
                    }
                })
            <<< PhoneRow() {
                $0.tag = "restaurantPhoneNumber"
                $0.title = "Phone Number"
                $0.placeholder = "+1 234 567 9012"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleExactLength(exactLength: 10))
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onChange({ (row) in
                    if let value = row.value, value.count == 10 {
                        self.restaurantPhoneNumberField = true
                    } else {
                        self.restaurantPhoneNumberField = false
                    }
                    
                    if self.isFormValidated() {
                        self.nextBarButtonItem.isEnabled = true
                    } else {
                        self.nextBarButtonItem.isEnabled = false
                    }
                })
            <<< AlertRow<String>() {
                $0.tag = "restaurantState"
                $0.title = "State"
                $0.selectorTitle = "Select State"
                $0.options = States
                $0.value = "CA"
                }
                .onPresent{ _, to in
                    to.view.tintColor = .blue
            }
            
            <<< ZipCodeRow() {
                $0.tag = "restaurantZipCode"
                $0.title = "Zip Code"
                $0.placeholder = "90210"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleExactLength(exactLength: 5))
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onChange({ (row) in
                    if let value = row.value, value.count == 5 {
                        self.restaurantZipCodeField = true
                    } else {
                        self.restaurantZipCodeField = false
                    }
                    
                    if self.isFormValidated() {
                        self.nextBarButtonItem.isEnabled = true
                    } else {
                        self.nextBarButtonItem.isEnabled = false
                    }
                })
        
    }
    
    // for enabling the Next Bar button
    // return true to skip form validation
    private func isFormValidated() -> Bool {
        let valuesDictionary = form.values()
        return valuesDictionary["userEmail"]! != nil && valuesDictionary["userPassword"]! != nil && valuesDictionary["restaurantName"]! != nil && valuesDictionary["restaurantStreet"]! != nil && valuesDictionary["restaurantCity"]! != nil && valuesDictionary["restaurantState"]! != nil && valuesDictionary["restaurantZipCode"]! != nil && emailField && passwordField && restaurantNameField && restaurantStreetField && restaurantCityField && restaurantPhoneNumberField && restaurantZipCodeField
    }
    
    private func getFormValues() -> (email: String, password: String, restaurantName: String, address: String, phoneNumber: String, image: UIImage) {
        let valuesDictionary = form.values()
        let email = (valuesDictionary["userEmail"] as! String)
        let password = (valuesDictionary["userPassword"] as! String)
        let restaurantName = (valuesDictionary["restaurantName"] as! String)
        
        let street = (valuesDictionary["restaurantStreet"] as! String)
        let city = (valuesDictionary["restaurantCity"] as! String)
        let state = (valuesDictionary["restaurantState"] as! String)
        let zipCode = (valuesDictionary["restaurantZipCode"] as! String)
        let address = "\(street) \(city) \(state) \(zipCode)"
        
        let phoneNumber = (valuesDictionary["restaurantPhoneNumber"] as! String)
        let restaurantImage = (valuesDictionary["restaurantImage"] as! UIImage)
        return (email: email, password: password, restaurantName: restaurantName, address: address, phoneNumber: phoneNumber, image: restaurantImage)
    }
    
    @objc func tapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapNext(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCreateMenuSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        
        let createMenuViewController = navVC.viewControllers.first as! CreateMenuViewController
        
        let (email, password, restaurantName, address, phoneNumber, image) = getFormValues()
        createMenuViewController.email = email
        createMenuViewController.password = password
        createMenuViewController.restaurantName = restaurantName
        createMenuViewController.address = address
        createMenuViewController.phoneNumber = phoneNumber
        createMenuViewController.restaurantImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up nav bar
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CreateRestaurantViewController.tapCancel(_:)))
        nav.leftBarButtonItem = cancelBarButtonItem
        
        nextBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(CreateRestaurantViewController.tapNext(_:)))
        nextBarButtonItem.isEnabled = false
        nav.rightBarButtonItem = nextBarButtonItem
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


