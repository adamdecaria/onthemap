//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-03-25.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController : UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var submitLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        enterLocationTextField.delegate = self
        websiteTextField.delegate = self
        
        mapView.isHidden = true
        submitLocationButton.isHidden = true
        
        mapView.delegate = self
        
        self.activityIndicator.color = UIColor.darkGray
        self.activityIndicator.stopAnimating()
        
    } // End viewWillAppear
    
    // ensure textField puts the keyboard away after use
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
        
    } // end textFieldShouldReturn
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        
        activityIndicator.isHidden = false
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        if enterLocationTextField.hasText && websiteTextField.hasText {
            if !(websiteTextField.text?.contains("http://"))! {
                let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter http:// before web address.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
                
                errorMessage.addAction(okAction)
                
                self.present(errorMessage, animated: true)
            }
            
            let userWebAddress = websiteTextField.text! as String
            User.sharedUser().webAddress = userWebAddress
            
            let userLocation = CLGeocoder()
            
            userLocation.geocodeAddressString(enterLocationTextField.text!, completionHandler: { placemark, error in
                
                if (error != nil) {
                    let errorMessage = UIAlertController.init(title: "Error", message: "Unable to find that location", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    errorMessage.addAction(okAction)
                    self.present(errorMessage, animated: true)
                } else {
                    
                    self.mapView.isHidden = false
                    self.submitLocationButton.isHidden = false
                    self.findLocationButton.isHidden = true
                    self.enterLocationTextField.isHidden = true
                    self.websiteTextField.isHidden = true
                    
                    let locationData = placemark?[0].location
                    User.sharedUser().latitude = (locationData?.coordinate.latitude)! as Double
                    User.sharedUser().longitude = (locationData?.coordinate.longitude)! as Double
                
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = (locationData?.coordinate)!
                
                    self.mapView.addAnnotation(annotation)
                    self.mapView.camera.centerCoordinate = (locationData?.coordinate)!
                    self.mapView.camera.altitude = self.mapView.camera.altitude * 0.2
                }
                
            })
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
        } else if !enterLocationTextField.hasText {
            let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter a location.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
            
            errorMessage.addAction(okAction)
            
            self.present(errorMessage, animated: true)
            
        } else if !websiteTextField.hasText {
            let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter a URL.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
            
            errorMessage.addAction(okAction)
            
            self.present(errorMessage, animated: true)
        }
        
    } // End findLocationButtonPressed
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    } // End mapView
    
    @IBAction func submitLocationButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            StudentData.shareStudentData().studentArray.removeAll()
            
            ParseClient.sharedInstance().taskForGETSession(completionHandler: {
                ParseClient.sharedInstance().taskForPOSTStudent(completionHandler: { error in
                    
                    guard (error == nil) else {
                        let errorMessage = UIAlertController.init(title: "Uhoh!", message: "Please check your network connection and try again.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        errorMessage.addAction(okAction)
                        self.present(errorMessage, animated: true)
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)})})
            
            self.activityIndicator.stopAnimating()
        }
        
    } // End submitLocationButtonPressed
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    } // End cancelButtonPressed
    
} // End InformationPostingViewController

