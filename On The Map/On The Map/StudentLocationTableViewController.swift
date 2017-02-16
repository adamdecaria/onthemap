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
    
    var studentList = [StudentLocation]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.hidesWhenStopped = true
        studentList = ParseClient.sharedInstance().shareStudentList()
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
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        ParseClient.sharedInstance().taskForGETMethod(completionHandler: { () -> Void in self.studentList = ParseClient.sharedInstance().shareStudentList()
            self.tableView.reloadData()
        })
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
 
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell")
        let student = studentList[indexPath.row]
     
        cell?.textLabel?.text = student.firstName + " " + student.lastName
        return cell!
    }
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
   */
} // End StudentLocationTableViewController
