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
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataFromParseAPI = ParseClient()
    var studentList = [StudentLocation]()
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
       
        print("LOGOUT button pressed")
        let _ = UdacityClient.sharedInstance().taskForPOSTDeleteSession()
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataFromParseAPI.taskForGETMethod()
        self.studentList = dataFromParseAPI.shareStudentList()
        self.createMapWithPins()
    
    } // End viewDidLoad
    
    func createMapWithPins()  {
        
        let data = self.studentList
        //print("This is the date from the parse API \(data)")
        
        var annotations = [MKPointAnnotation]()
            
        for element in data {
                
            let lat = CLLocationDegrees(element.latitude)
            //print(element.longitude)
            let long = CLLocationDegrees(element.longitude)
            //print(element.latitude)
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
    }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
} // End MapViewController
