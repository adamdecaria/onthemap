//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-02-24.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import MapKit
import UIKit

class InformationPostingViewController : UIViewController, MKMapViewDelegate, UITextViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var userEntryTextField: UITextView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.isHidden = true
        mapTextView.isHidden = true
        submitButton.isHidden = true
        
        userEntryTextField.delegate = self
        mapView.delegate = self
        
        activityViewIndicator.hidesWhenStopped = true
        
    } // End viewWillAppear
    
    
    // MARK: dismiss InformationPostingViewController when Cancel button pressed
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    } // end cancelButtonPressed
    
    @IBAction func findButtonPressed(_ sender: Any) {
        
        mainTextView.isHidden = true
        mainTextView.delegate = nil
        userEntryTextField.isHidden = true
        findButton.isHidden = true
        
        mapTextView.delegate = self
        mapTextView.isHidden = false
        mapView.isHidden = false
        submitButton.isHidden = false
        
        let userLocation = CLGeocoder()
        userLocation.geocodeAddressString(userEntryTextField.text, completionHandler: { placemark, error in
            
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
            
            User.sharedUser().mapString = self.mainTextView.text
            User.sharedUser().webAddress = self.mapTextView.text

            let annotation = MKPointAnnotation()
            annotation.coordinate = (locationData?.coordinate)!

            self.mapView.addAnnotation(annotation)
            self.mapView.camera.centerCoordinate = (locationData?.coordinate)!
            self.mapView.camera.altitude = self.mapView.camera.altitude * 0.2
        })
        
    } // End findButtonPressed
    
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n" {
            return textView.resignFirstResponder()
        }
        return true
    } // End textView
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        if !mapTextView.hasText {
            let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter a URL.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
            
            errorMessage.addAction(okAction)
            
            self.present(errorMessage, animated: true)
        } else {
            ParseClient.sharedInstance().taskForGETSession(completionHandler: { _ in ParseClient.sharedInstance().taskForPOSTStudent() })
        }
 
    } // End submitButtonPressed
    
    
} // End InformationPostingViewController

