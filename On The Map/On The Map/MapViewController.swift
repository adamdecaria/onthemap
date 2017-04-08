//
//  MapViewController.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-01-15.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.stopAnimating()
        
        ParseClient.sharedInstance().taskForGETMethod(completionHandler: { (_ error) -> Void in
            
            guard(error == nil) else {
                let errorMessage = UIAlertController.init(title: "Network Error", message: "Please check network connection and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                errorMessage.addAction(okAction)
                self.present(errorMessage, animated: true)
                self.activityIndicator.stopAnimating()
                return
            }
            DispatchQueue.main.async {
                self.createMapWithPins()
            }
        })
        
    } // End viewWillAppear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    } // End viewDidLoad
 
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        let _ = UdacityClient.sharedInstance().taskForPOSTDeleteSession(completionHandler: { () -> Void in
            self.dismiss(animated: true, completion: nil) })
        self.activityIndicator.stopAnimating()
    
    } // End logoutButtonPressed

    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        
        self.mapView.removeAnnotations(mapView.annotations)
      
        DispatchQueue.global(qos: .userInitiated).async {
        
            ParseClient.sharedInstance().taskForGETMethod(completionHandler: { (_ error) -> Void in
            
                guard(error == nil) else {
                    let errorMessage = UIAlertController.init(title: "Network Error", message: "Please check network connection and try again.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    errorMessage.addAction(okAction)
                    self.present(errorMessage, animated: true)
                    self.activityIndicator.stopAnimating()
                    return
                }
            })
        }
        
        DispatchQueue.main.async {
            self.createMapWithPins()
        }
    
    } // End refreshButtonPressed
    
    func createMapWithPins()  {

        let data = StudentData.shareStudentData().studentArray
        
        var annotations = [MKPointAnnotation]()
        
        for element in data {
            
            let lat = CLLocationDegrees(element.latitude)
            let long = CLLocationDegrees(element.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = element.firstName
            let lastName = element.lastName
    
            
            let mediaURL = element.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            // store the individual annotation in an array of annotations
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)

    } // End createMapWithPins
    
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
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    } // End mapView
    
} // End MapViewController
