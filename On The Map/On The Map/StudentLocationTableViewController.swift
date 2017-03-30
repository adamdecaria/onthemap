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
    @IBOutlet var studentDataTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.color = UIColor.darkGray
        activityIndicator.hidesWhenStopped = true
        
        ParseClient.sharedInstance().taskForGETMethod(completionHandler: { (_ error) -> Void in
            
            guard(error == nil) else {
                let errorMessage = UIAlertController.init(title: "Network Error", message: "Please check network connection and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                errorMessage.addAction(okAction)
                self.present(errorMessage, animated: true)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.studentDataTableView.reloadData()
        })
        
    } // End viewWillAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        studentDataTableView.delegate = self
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
        print("refresh button pressed.")
        ParseClient.sharedInstance().taskForGETMethod(completionHandler: { (_ error) -> Void in
            
            guard(error == nil) else {
                let errorMessage = UIAlertController.init(title: "Network Error", message: "Please check network connection and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                errorMessage.addAction(okAction)
                self.present(errorMessage, animated: true)
                self.activityIndicator.stopAnimating()
                return
            }
            self.studentDataTableView.reloadData()
        })

        
    } // End refreshButtonPressed
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentData.shareStudentData().studentArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationTableViewCell")
        let student = StudentData.shareStudentData().studentArray[indexPath.row]
        
        cell?.textLabel?.text = student.firstName + " " + student.lastName
        return cell!
    } // End tableView
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = StudentData.shareStudentData().studentArray[indexPath.row]
        let studentURL = student.mediaURL
        
        let app = UIApplication.shared
        app.open(URL(string: studentURL)!, options: [:], completionHandler: nil)
        
    } // End tableView
   
} // End StudentLocationTableViewController
