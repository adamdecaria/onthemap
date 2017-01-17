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
    
    var parseTest = ParseClient()
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
       
        print("LOGOUT button pressed")
        let _ = UdacityClient.sharedInstance().taskForPOSTDeleteSession()
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = parseTest.taskForGETMethod()
    }
    
} // End MapViewController
