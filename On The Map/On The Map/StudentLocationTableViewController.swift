//
//  StudentLocationTableController.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-02-13.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation
import UIKit

class StudentLocationTableViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.hidesWhenStopped = true
        tableView.reloadData()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        let _ = UdacityClient.sharedInstance().taskForPOSTDeleteSession(completionHandler: { () -> Void in
            self.dismiss(animated: true, completion: nil) })
        self.activityIndicator.stopAnimating()
    
    } // End logoutButtonPressed
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        /*
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        self.dataFromParseAPI.taskForGETMethod(completionHandler: { () -> Void in self.studentList = self.dataFromParseAPI.shareStudentList()
            self.createMapWithPins()
        })
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
 */
    }
    
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell")
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    */
} // End StudentLocationTableViewController
