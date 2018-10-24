//
//  AddToMenuViewController.swift
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

class AddToMenuViewController: FormViewController {

    @IBOutlet weak var nav: UINavigationItem!
    var restaurant: Restaurant!
    var createBarButtonItem: UIBarButtonItem!
    
    // for form validation
    var dishNameField = false
    var dishPriceField = false
    var dishDescriptionField = false
    
    private func initializeForm() {
        form
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
    
    // for enabling the Add Bar button
    // return true to skip form validation
    private func isFormValidated() -> Bool {
        let valuesDictionary = form.values()
        return valuesDictionary["dishName"]! != nil && valuesDictionary["dishPhoto"]! != nil && valuesDictionary["dishPrice"]! != nil && valuesDictionary["dishDescription"]! != nil && dishNameField && dishPriceField && dishDescriptionField
    }
    
    private func getFormValues() -> (dishName: String, dishPhoto: UIImage, dishPrice: String, dishDescription: String) {
        let valuesDictionary = form.values()
        
        let dishName = (valuesDictionary["dishName"] as! String)
        let dishPhoto = (valuesDictionary["dishPhoto"] as! UIImage)
        let dishPrice = String(valuesDictionary["dishPrice"] as! Double)
        let dishDescription = (valuesDictionary["dishDescription"] as! String)
        
        return (dishName: dishName, dishPhoto: dishPhoto, dishPrice: dishPrice, dishDescription: dishDescription)
    }
    
    @objc func tapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapCreate(_ sender: Any) {
        let (dishName, dishPhoto, dishPrice, dishDescription) = getFormValues()
        
        let newMenuItem = MenuItem()
        newMenuItem.photo = MenuItem.getPFFileFromImage(dishPhoto)!
        newMenuItem.name = dishName
        newMenuItem.price = dishPrice
        newMenuItem.menuItemDescription = dishDescription
        
        // show PKHUD
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        newMenuItem.addUniqueObject(restaurant, forKey: "restaurant")
        newMenuItem.saveInBackground { (success: Bool, error: Error?) in
            if success {
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                    self.dismiss(animated: true, completion: nil)
                })
                
            } else {
                print("new menu item save in background error: \(error!)")
                self.displayError(error!)
            }
        }
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

        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AddToMenuViewController.tapCancel(_:)))
        nav.leftBarButtonItem = cancelBarButtonItem
        
        createBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(AddToMenuViewController.tapCreate(_:)))
        createBarButtonItem.isEnabled = false
        nav.rightBarButtonItem = createBarButtonItem
        
        // title of nav
        nav.title = "Add to Menu"
        
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
