//
//  CreateMenuViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/18/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit
import Parse

class CreateMenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var email: String!
    var password: String!
    var restaurantName: String!
    var addressName: String!
    var phoneNumber: String!
    var restaurantHours: String!
    var restaurantImage: UIImage!

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodPriceTextField: UITextField!
    @IBOutlet weak var foodDescriptionTextField: UITextField!
    
    @IBAction func tapNewFoodPhoto(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let resizedImage = resize(image: originalImage, newSize: CGSize(width: 300, height: 300))
        self.dismiss(animated: true, completion: nil)
        
        foodImageView.contentMode = .scaleToFill
        foodImageView.image = resizedImage
    }
    
    // resizing image before uploading to Parse
    private func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func tapCreate(_ sender: Any) {
        // create new user and then create new restaurant
        let newUser = PFUser()
        newUser.username = email
        newUser.password = password

        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                
                Restaurant.createRestaurant(image: self.restaurantImage, name: self.restaurantName, hours: self.restaurantHours, phoneNumber: self.phoneNumber, email: self.email) { (success: Bool, error: Error?) in
                    
                    if success {
                        print("Successssssssssss")
                        
                    } else {
                        print("Create Restaurant Error")
                    }
                }

            } else {
                print("New User Sign Up Error")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantNameLabel.text = restaurantName
    }

}
