//
//  AddRestaurantViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/23/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import PKHUD
import Parse

class AddRestaurantViewController: FormViewController {
    
    @IBOutlet weak var nav: UINavigationItem!
    var createBarButtonItem: UIBarButtonItem!
    
    // for form validation
    var restaurantNameField = false
    var restaurantPhoneNumberField = false
    var restaurantStreetField = false
    var restaurantCityField = false
    var restaurantZipCodeField = false
    
    private func initializeForm() {
        form
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
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
                    }
                })
            <<< ImageRow() {
                $0.tag = "restaurantImage"
                $0.title = "Photo"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.value = UIImage(named: "iconmonstr-eat")
                $0.clearAction = .no
            }
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
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
                    }
                })
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
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
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
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
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
        return valuesDictionary["restaurantName"]! != nil && valuesDictionary["restaurantPhoneNumber"]! != nil && valuesDictionary["restaurantStreet"]! != nil && valuesDictionary["restaurantCity"]! != nil && valuesDictionary["restaurantState"]! != nil && valuesDictionary["restaurantZipCode"]! != nil && restaurantNameField && restaurantPhoneNumberField && restaurantStreetField && restaurantCityField &&  restaurantZipCodeField
    }
    
    private func getFormValues() -> (restaurantName: String, restaurantImage: UIImage, restaurantPhoneNumber: String, restaurantStreet: String, restaurantCity: String, restaurantState: String, restaurantZipCode: String) {
        let valuesDictionary = form.values()
        
        let restaurantName = (valuesDictionary["restaurantName"] as! String)
        let restaurantImage = (valuesDictionary["restaurantImage"] as! UIImage)
        let restaurantPhoneNumber = (valuesDictionary["restaurantPhoneNumber"] as! String)
        
        let street = (valuesDictionary["restaurantStreet"] as! String)
        let city = (valuesDictionary["restaurantCity"] as! String)
        let state = (valuesDictionary["restaurantState"] as! String)
        let zipCode = (valuesDictionary["restaurantZipCode"] as! String)
        
        return (restaurantName: restaurantName, restaurantImage: restaurantImage, restaurantPhoneNumber: restaurantPhoneNumber, restaurantStreet: street, restaurantCity: city, restaurantState: state, restaurantZipCode: zipCode)
    }
    
    @objc func tapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapCreate(_ sender: Any) {
        let (restaurantName, restaurantImage, restaurantPhoneNumber, restaurantStreet, restaurantCity, restaurantState, restaurantZipCode) = getFormValues()
        
        let newUserRestaurant = Restaurant()
        newUserRestaurant.photo = Restaurant.getPFFileFromImage(restaurantImage)!
        newUserRestaurant.name = restaurantName
        newUserRestaurant.phoneNumber = restaurantPhoneNumber
        newUserRestaurant.street = restaurantStreet
        newUserRestaurant.city = restaurantCity
        newUserRestaurant.state = restaurantState
        newUserRestaurant.zipCode = restaurantZipCode
        newUserRestaurant.addUniqueObject(PFUser.current()!, forKey: "user")
        
        // show PKHUD
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        newUserRestaurant.saveInBackground(block: { (success: Bool, error: Error?) in
            
            if success {
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                    self.dismiss(animated: true, completion: nil)
                })
                
            } else {
                print("new user restaurant save in background error: \(error!)")
                self.displayError(error!)
            }
            
        })
        
    }
    
    private func displayError(_ error: Error) {
        PKHUD.sharedHUD.hide(animated: true)
        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up nav bar
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AddRestaurantViewController.tapCancel(_:)))
        cancelBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nav.leftBarButtonItem = cancelBarButtonItem
        
        createBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(AddRestaurantViewController.tapCreate(_:)))
        createBarButtonItem.isEnabled = false
        createBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nav.rightBarButtonItem = createBarButtonItem
        nav.title = "New Restaurant"
        
        // Enables the navigation accessory and stops navigation when a disabled row is encountered
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // Enables smooth scrolling on navigation to off-screen rows
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
        
        initializeForm()
    }
    
}
