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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.isHidden = true
        mapTextView.isHidden = true
        submitButton.isHidden = true
        
        userEntryTextField.delegate = self
        mapView.delegate = self
        
    } // End viewWillAppear
    
    
    // MARK: dismiss InformationPostingViewController when Cancel button pressed
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    } // end cancelButtonPressed
    
    @IBAction func findButtonPressed(_ sender: Any) {
        
        mainTextView.isHidden = true
        userEntryTextField.isHidden = true
        findButton.isHidden = true
        
        mapTextView.isHidden = false
        mapView.isHidden = false
        submitButton.isHidden = false
        
        let userLocation = CLGeocoder()
        userLocation.geocodeAddressString(userEntryTextField.text, completionHandler: { placemark, error in
            
            guard (error == nil) else {
                print("There was an error getting user location")
                return
            }
            
            let locationData = placemark?[0].location
            let annotation = MKPointAnnotation()
            annotation.coordinate = (locationData?.coordinate)!
            self.mapView.addAnnotation(annotation)
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            return textView.resignFirstResponder()
        }
        return true
    } // End textView
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        

    }
    
    
} // End InformationPostingViewController

