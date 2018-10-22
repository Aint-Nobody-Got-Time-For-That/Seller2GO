//
//  CreateMenuViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/18/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse
import Eureka
import ImageRow

class CreateMenuViewController: FormViewController {
    
    @IBOutlet weak var nav: UINavigationItem!
    var createBarButtonItem: UIBarButtonItem!
    
    var email: String!
    var password: String!
    var restaurantName: String!
    var address: String!
    var phoneNumber: String!
    var restaurantImage: UIImage!
    
    // all form validation
    var nameField = false
    var priceField = false
    var descriptionField = false
    
    private func initializeForm() {
        form
            +++ Section("Dish")
            <<< NameRow() {
                $0.tag = "name"
                $0.title = "Name"
                $0.placeholder = "Fish Taco"
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
                        self.nameField = true
                    } else {
                        self.nameField = false
                    }
                    
                    if self.isFormValidated() {
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
                    }
                })
            <<< ImageRow() {
                $0.tag = "photo"
                $0.title = "Photo"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.value = UIImage(named: "iconmonstr-eat")
                $0.clearAction = .no
            }
            <<< DecimalRow() {
                $0.tag = "price"
                $0.useFormatterDuringInput = true
                $0.title = "Price"
                $0.placeholder = "0"
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
                }.onChange({ (row) in
                    if row.value != nil {
                        self.priceField = true
                    } else {
                        self.priceField = false
                    }
                    
                    if self.isFormValidated() {
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
                    }
                })
            <<< TextAreaRow() {
                $0.tag = "description"
                $0.placeholder = "Description"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleGreaterOrEqualThan(min: "1"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }.onChange({ (row) in
                    if let value = row.value, value.count >= 1 {
                        self.descriptionField = true
                    } else {
                        self.descriptionField = false
                    }
                    
                    if self.isFormValidated() {
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
                    }
                })
    }
    
    private func getFormValues() -> (name: String, photo: UIImage, price: String, description: String) {
        let valuesDictionary = form.values()
        
        let name = (valuesDictionary["name"] as! String)
        let photo = (valuesDictionary["photo"] as! UIImage)
        let price = (valuesDictionary["price"] as! Double)
        let description = (valuesDictionary["description"] as! String)
        return (name: name, photo: photo, price: String(price), description: description)
    }
    
    @objc func tapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapCreate(_ sender: Any) {
        let (name, photo, price, description) = getFormValues()
        
        let newUser = PFUser()
        newUser.username = email
        newUser.password = password
        
        let newUserRestaurant = Restaurant()
        newUserRestaurant.photo = Restaurant.getPFFileFromImage(restaurantImage)!
        newUserRestaurant.name = restaurantName
        newUserRestaurant.address = address
        newUserRestaurant.phoneNumber = phoneNumber
        
        let newMenuItem = MenuItem()
        newMenuItem.photo = MenuItem.getPFFileFromImage(photo)!
        newMenuItem.name = name
        newMenuItem.price = price
        newMenuItem.menuItemDescription = description
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                newMenuItem.addUniqueObject(newUserRestaurant, forKey: "restaurant")
                newMenuItem.saveInBackground { (success: Bool, error: Error?) in
                    if success {
                        
                        newUserRestaurant.addUniqueObject(newUser, forKey: "user")
                        newUserRestaurant.saveInBackground(block: { (success: Bool, error: Error?) in
                            
                            if success {
                                self.performSegue(withIdentifier: "goToRestaurantDetailSegue", sender: nil)
                            } else {
                                print("new user restaurant save in background error")
                                print(error!)
                            }
                            
                        })
                        
                    } else {
                        print("new menu item save in background error")
                        print(error!)
                    }
                }
            } else {
                print("New User Sign Up Error")
                print(error!)
            }
        }
    }
    
    // for enabling the Create Bar button
    // return true to skip form validation
    private func isFormValidated() -> Bool {
        let valuesDictionary = form.values()
        
//        print(valuesDictionary["name"]!)
//        print(valuesDictionary["photo"]!)
//        print(valuesDictionary["price"]!)
//        print(valuesDictionary["description"]!)
//        print(nameField)
//        print(descriptionField)
        
        return valuesDictionary["name"]! != nil && valuesDictionary["photo"]! != nil && valuesDictionary["price"]! != nil && valuesDictionary["description"]! != nil && nameField && descriptionField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up nav bar
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(CreateMenuViewController.tapBack(_:)))
        nav.leftBarButtonItem = backBarButtonItem
        
        createBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(CreateMenuViewController.tapCreate(_:)))
        createBarButtonItem.isEnabled = false
        nav.rightBarButtonItem = createBarButtonItem
        
        nav.title = restaurantName
        
        // Enables the navigation accessory and stops navigation when a disabled row is encountered
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // Enables smooth scrolling on navigation to off-screen rows
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
        
        initializeForm()
        
    }
    
    class CurrencyFormatter : NumberFormatter, FormatterProtocol {
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
            guard obj != nil else { return }
            var str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if !string.isEmpty, numberStyle == .currency && !string.contains(currencySymbol) {
                // Check if the currency symbol is at the last index
                if let formattedNumber = self.string(from: 1), String(formattedNumber[formattedNumber.index(before: formattedNumber.endIndex)...]) == currencySymbol {
                    // This means the user has deleted the currency symbol. We cut the last number and then add the symbol automatically
                    str = String(str[..<str.index(before: str.endIndex)])
                    
                }
            }
            obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
        }
        
        func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
            return textInput.position(from: position, offset:((newValue?.count ?? 0) - (oldValue?.count ?? 0))) ?? position
        }
    }
    
}
