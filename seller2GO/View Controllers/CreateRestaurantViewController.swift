//
//  CreateRestaurantViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/18/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit

class CreateRestaurantViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var restaurantTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBAction func onTapNext(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCreateMenuSegue", sender: nil)
    }
    
    @IBAction func tapNewRestaurantPhoto(_ sender: Any) {
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
        
        restaurantImageView.contentMode = .scaleToFill
        restaurantImageView.image = resizedImage
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createMenuViewController = segue.destination as! CreateMenuViewController
        
        createMenuViewController.email = emailTextField.text!
        createMenuViewController.password = passwordTextField.text!
        createMenuViewController.restaurantName = restaurantTextField.text!
        createMenuViewController.addressName = addressTextField.text!
        createMenuViewController.phoneNumber = phoneNumberTextField.text!
        createMenuViewController.restaurantHours = hoursTextField.text!
        createMenuViewController.restaurantImage = restaurantImageView.image!
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
