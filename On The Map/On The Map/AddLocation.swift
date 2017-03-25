//
//  AddLocation.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-03-25.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit
import MapKit

class AddLocation : UIViewController, UITextFieldDelegate {
    
    
    // MARK: Outlets
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        websiteTextField.delegate = self
        enterLocationTextField.delegate = self
        
    } // End viewWillAppear
    
    // ensure textField puts the keyboard away after use
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
        
    } // end textFieldShouldReturn
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
    
        let userLocation = CLGeocoder()
        
        userLocation.geocodeAddressString(enterLocationTextField.text!, completionHandler: { placemark, error in
            
            guard (error == nil) else {
                let errorMessage = UIAlertController.init(title: "Error", message: "Unable to find that location", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                errorMessage.addAction(okAction)
                self.present(errorMessage, animated: true)
                return
            }
            
            let locationData = placemark?[0].location
            User.sharedUser().latitude = (locationData?.coordinate.latitude)! as Double
            User.sharedUser().longitude = (locationData?.coordinate.longitude)! as Double
        })
        
        let navigationController = (self.storyboard?.instantiateViewController(withIdentifier: "LocationFinderViewController"))! as UIViewController
        self.present(navigationController, animated: true, completion: nil)
    
    } // End findLocationButtonPressed

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    } // End cancelButtonPressed
    
    
} // End AddLocation
