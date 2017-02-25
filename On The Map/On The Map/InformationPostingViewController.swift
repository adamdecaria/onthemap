//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-02-24.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import MapKit
import UIKit

class InformationPostingViewController : UIViewController, MKMapViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var userEntryTextField: UITextView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTextView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.isHidden = true
        mapTextView.isHidden = true
        
    }
    
    
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
    } // End findButtonPressed
    
} // End InformationPostingViewController

