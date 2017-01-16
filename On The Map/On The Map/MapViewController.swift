//
//  MapViewController.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-01-15.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit

class MapViewController : UIViewController {
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
       
        print("LOGOUT button pressed")
        let _ = UdacityClient.sharedInstance().taskForPOSTDeleteSession()
        self.dismiss(animated: true, completion: nil)
    }

} // End MapViewController
