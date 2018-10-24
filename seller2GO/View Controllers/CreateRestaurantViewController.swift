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
import Parse
import PKHUD

class CreateRestaurantViewController: FormViewController {
    
    @IBOutlet weak var nav: UINavigationItem!
    var createBarButtonItem: UIBarButtonItem!
    
    // all form validation
    var emailField = false
    var passwordField = false
    var restaurantNameField = false
    var restaurantPhoneNumberField = false
    var restaurantStreetField = false
    var restaurantCityField = false
    var restaurantZipCodeField = false
    var dishNameField = false
    var dishPriceField = false
    var dishDescriptionField = false
    
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
        
            +++ Section("Dish")
            <<< NameRow() {
                $0.tag = "dishName"
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
                        self.dishNameField = true
                    } else {
                        self.dishNameField = false
                    }
                    
                    if self.isFormValidated() {
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
                    }
                })
            <<< ImageRow() {
                $0.tag = "dishPhoto"
                $0.title = "Photo"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.value = UIImage(named: "iconmonstr-eat")
                $0.clearAction = .no
            }
            <<< DecimalRow() {
                $0.tag = "dishPrice"
                $0.useFormatterDuringInput = true
                $0.title = "Price"
                $0.placeholder = "0"
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
                }.onChange({ (row) in
                    if row.value != nil {
                        self.dishPriceField = true
                    } else {
                        self.dishPriceField = false
                    }
                    
                    if self.isFormValidated() {
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
                    }
                })
            <<< TextAreaRow() {
                $0.tag = "dishDescription"
                $0.placeholder = "Description"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleGreaterOrEqualThan(min: "1"))
                $0.validationOptions = .validatesOnChangeAfterBlurred
                }.onChange({ (row) in
                    if let value = row.value, value.count >= 1 {
                        self.dishDescriptionField = true
                    } else {
                        self.dishDescriptionField = false
                    }
                    
                    if self.isFormValidated() {
                        self.createBarButtonItem.isEnabled = true
                    } else {
                        self.createBarButtonItem.isEnabled = false
                    }
                })
        
    }
    
    // for enabling the Next Bar button
    // return true to skip form validation
    private func isFormValidated() -> Bool {
        let valuesDictionary = form.values()
        return valuesDictionary["userEmail"]! != nil && valuesDictionary["userPassword"]! != nil && valuesDictionary["restaurantName"]! != nil && valuesDictionary["restaurantPhoneNumber"]! != nil && valuesDictionary["restaurantStreet"]! != nil && valuesDictionary["restaurantCity"]! != nil && valuesDictionary["restaurantState"]! != nil && valuesDictionary["restaurantZipCode"]! != nil && valuesDictionary["dishName"]! != nil && valuesDictionary["dishPhoto"]! != nil && valuesDictionary["dishPrice"]! != nil && valuesDictionary["dishDescription"]! != nil && emailField && passwordField && restaurantNameField && restaurantPhoneNumberField && restaurantStreetField && restaurantCityField &&  restaurantZipCodeField && dishNameField && dishPriceField && dishDescriptionField
    }
    
    private func getFormValues() -> (email: String, password: String, restaurantName: String, restaurantImage: UIImage, restaurantPhoneNumber: String,  restaurantAddress: String, dishName: String, dishPhoto: UIImage, dishPrice: String, dishDescription: String) {
        let valuesDictionary = form.values()
        let email = (valuesDictionary["userEmail"] as! String)
        let password = (valuesDictionary["userPassword"] as! String)
        
        let restaurantName = (valuesDictionary["restaurantName"] as! String)
        let restaurantImage = (valuesDictionary["restaurantImage"] as! UIImage)
        let restaurantPhoneNumber = (valuesDictionary["restaurantPhoneNumber"] as! String)
        
        let street = (valuesDictionary["restaurantStreet"] as! String)
        let city = (valuesDictionary["restaurantCity"] as! String)
        let state = (valuesDictionary["restaurantState"] as! String)
        let zipCode = (valuesDictionary["restaurantZipCode"] as! String)
        let restaurantAddress = "\(street) \(city) \(state) \(zipCode)"
        
        let dishName = (valuesDictionary["dishName"] as! String)
        let dishPhoto = (valuesDictionary["dishPhoto"] as! UIImage)
        let dishPrice = String(valuesDictionary["dishPrice"] as! Double)
        let dishDescription = (valuesDictionary["dishDescription"] as! String)
        
        return (email: email, password: password, restaurantName: restaurantName, restaurantImage: restaurantImage, restaurantPhoneNumber: restaurantPhoneNumber,  restaurantAddress: restaurantAddress, dishName: dishName, dishPhoto: dishPhoto, dishPrice: dishPrice, dishDescription: dishDescription)
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
        
        let (email, password, restaurantName, restaurantImage, restaurantPhoneNumber, restaurantAddress, dishName, dishPhoto, dishPrice, dishDescription) = getFormValues()
        
        let newUser = PFUser()
        newUser.username = email
        newUser.password = password
        
        let newUserRestaurant = Restaurant()
        newUserRestaurant.photo = Restaurant.getPFFileFromImage(restaurantImage)!
        newUserRestaurant.name = restaurantName
        newUserRestaurant.address = restaurantAddress
        newUserRestaurant.phoneNumber = restaurantPhoneNumber
        
        let newMenuItem = MenuItem()
        newMenuItem.photo = MenuItem.getPFFileFromImage(dishPhoto)!
        newMenuItem.name = dishName
        newMenuItem.price = dishPrice
        newMenuItem.menuItemDescription = dishDescription
        
        // show PKHUD
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                newMenuItem.addUniqueObject(newUserRestaurant, forKey: "restaurant")
                newMenuItem.saveInBackground { (success: Bool, error: Error?) in
                    if success {
                        
                        newUserRestaurant.addUniqueObject(newUser, forKey: "user")
                        newUserRestaurant.saveInBackground(block: { (success: Bool, error: Error?) in
                            
                            if success {
                                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                                PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                                    self.performSegue(withIdentifier: "goToRestaurantDetailSegue", sender: nil)
                                })
                                
                            } else {
                                print("new user restaurant save in background error: \(error!)")
                                self.displayError(error!)
                            }
                            
                        })
                        
                    } else {
                        print("new menu item save in background error: \(error!)")
                        self.displayError(error!)
                    }
                }
            } else {
                
                print("New User Sign Up Error: \(error!)")
                self.displayError(error!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up nav bar
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CreateRestaurantViewController.tapCancel(_:)))
        nav.leftBarButtonItem = cancelBarButtonItem
        
        createBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(CreateRestaurantViewController.tapCreate(_:)))
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
