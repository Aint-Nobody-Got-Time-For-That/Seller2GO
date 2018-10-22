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
            }
            <<< PasswordRow() {
                $0.tag = "userPassword"
                $0.title = "Password"
                $0.placeholder = "·····"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleGreaterOrEqualThan(min: "3"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
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
            }
            <<< ImageRow() {
                $0.tag = "restaurantImage"
                $0.title = "Photo"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.value = UIImage(named: "iconmonstr-eat")
            }
            <<< TextRow() {
                $0.tag = "restaurantStreet"
                $0.title = "Street"
                $0.placeholder = "123 Jane Street"
            }
            <<< TextRow() {
                $0.tag = "restaurantCity"
                $0.title = "City"
                $0.placeholder = "San Francisco"
            }
            <<< PhoneRow() {
                $0.tag = "restaurantPhoneNumber"
                $0.title = "Phone Number"
                $0.placeholder = "+1 23456789"
            }
            <<< AlertRow<String>() {
                $0.tag = "restaurantState"
                $0.title = "State"
                $0.selectorTitle = "Select State"
                $0.options = States
                $0.value = "CA"
                }
                .onPresent{ _, to in
                    to.view.tintColor = .purple
            }
            
            <<< ZipCodeRow() {
                $0.tag = "resturantZipCode"
                $0.title = "Zip Code"
                $0.placeholder = "90210"
        }
        
        
        let valuesDictionary = form.values()
        print(valuesDictionary)
    }
    
    @objc func tapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapNext(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCreateMenuSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up nav bar
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CreateRestaurantViewController.tapCancel(_:)))
        nav.leftBarButtonItem = cancelBarButtonItem
        
        let nextBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(CreateRestaurantViewController.tapNext(_:)))
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


