//
//  EditMenuItemViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/26/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import PKHUD
import Parse

class EditMenuItemViewController: FormViewController {

    @IBOutlet weak var nav: UINavigationItem!
    var menuItem: MenuItem!
    var editBarButtonItem: UIBarButtonItem!
    
    // for form validation
    var dishNameField = true
    var dishPriceField = true
    var dishDescriptionField = true
    
    private func initializeForm() {
        form
            +++ Section("Dish", { (Section) in
                Section.tag = "Dish"
            })
            <<< NameRow() {
                $0.value = menuItem.name
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
                        self.editBarButtonItem.isEnabled = true
                    } else {
                        self.editBarButtonItem.isEnabled = false
                    }
                })
            <<< ImageRow() {
                $0.value = UIImage(named: "iconmonstr-eat")
                $0.tag = "dishPhoto"
                $0.title = "Photo"
                $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                $0.clearAction = .no
                }.onChange({ (ImageRow) in
                    if self.isFormValidated() {
                        self.editBarButtonItem.isEnabled = true
                    } else {
                        self.editBarButtonItem.isEnabled = false
                    }
                })
            <<< DecimalRow() {
                $0.value = Double(menuItem.price)
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
                        self.editBarButtonItem.isEnabled = true
                    } else {
                        self.editBarButtonItem.isEnabled = false
                    }
                })
            <<< TextAreaRow() {
                $0.value = menuItem.menuItemDescription
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
                        self.editBarButtonItem.isEnabled = true
                    } else {
                        self.editBarButtonItem.isEnabled = false
                    }
                })
    }
    
    // for enabling the Edit Bar button
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
    
    @objc func tapEdit(_ sender: Any) {
        let (dishName, dishPhoto, dishPrice, dishDescription) = getFormValues()
        
        menuItem.photo = MenuItem.getPFFileFromImage(dishPhoto)!
        menuItem.name = dishName
        menuItem.price = dishPrice
        menuItem.menuItemDescription = dishDescription
        
        // show PKHUD
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        menuItem.saveInBackground { (success: Bool, error: Error?) in
            if success {
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                PKHUD.sharedHUD.hide(afterDelay: 0.3, completion: { (success) in
                    self.dismiss(animated: true, completion: nil)
                })
                
            } else {
                print("edit menu item save in background error: \(error!)")
                self.displayError(error!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up nav bar
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditMenuItemViewController.tapCancel(_:)))
        cancelBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nav.leftBarButtonItem = cancelBarButtonItem
        
        editBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(EditMenuItemViewController.tapEdit(_:)))
        editBarButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        editBarButtonItem.isEnabled = false
        nav.rightBarButtonItem = editBarButtonItem
        nav.title = "Edit Menu Item"
        
        // Enables the navigation accessory and stops navigation when a disabled row is encountered
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // Enables smooth scrolling on navigation to off-screen rows
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
        
        initializeForm()
        
        menuItem.photo.getDataInBackground { (imageData: Data?, error: Error?) in
            if let imageData = imageData {
                let image = UIImage(data: imageData)
                self.form.setValues(["dishPhoto": image!])
                let section: Section?  = self.form.sectionBy(tag: "Dish")
                section?.reload()
            }
        }
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
