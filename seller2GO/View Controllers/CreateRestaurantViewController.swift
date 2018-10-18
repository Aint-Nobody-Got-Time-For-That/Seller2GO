//
//  CreateRestaurantViewController.swift
//  seller2GO
//
//  Created by Victor Li on 10/18/18.
//  Copyright © 2018 Aint Nobody Got Time For That. All rights reserved.
//

import UIKit

class CreateRestaurantViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var restaurantTextLabel: UITextField!
    @IBOutlet weak var addressTextLabel: UITextField!
    @IBOutlet weak var phoneNumberTextLabel: UITextField!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    var email: String!
    var password: String!
    
    @IBAction func onTapNext(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCreateMenuSegue", sender: nil)
    }
    
    @IBAction func tapNewPhoto(_ sender: Any) {
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
        createMenuViewController.email = email
        createMenuViewController.password = password
        createMenuViewController.restaurantName = restaurantTextLabel.text!
        createMenuViewController.addressName = addressTextLabel.text!
        createMenuViewController.phoneNumber = phoneNumberTextLabel.text!
        createMenuViewController.restaurantImage = restaurantImageView.image!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
