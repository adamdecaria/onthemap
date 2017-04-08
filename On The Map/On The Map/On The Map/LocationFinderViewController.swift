//
//  LocationFinderViewController.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-03-25.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit
import MapKit

class LocationFinderViewController : UIViewController, MKMapViewDelegate {
    
    
    @IBAction func submitLocationButton(_ sender: Any) {
    
        ParseClient.sharedInstance().taskForGETSession(completionHandler: { _ in ParseClient.sharedInstance().taskForPOSTStudent() })
    } // End submitLocationButton
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    
} // End LocationFinderViewController

