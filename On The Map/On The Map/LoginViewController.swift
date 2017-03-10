//
//  ViewController.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-01-11.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // textField for email entry to login
    @IBOutlet weak var emailTextField: UITextField!
    
    // textField for password entry to login
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.activityIndicator.stopAnimating()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    } // End viewWillAppear
    
    // ensure textField puts the keyboard away after use
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        return textField.resignFirstResponder()
        
    } // end textFieldShouldReturn
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        
        if emailTextField.hasText && passwordTextField.hasText {
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            
            UdacityClient.sharedInstance().getLoginInfo(username: emailTextField.text!, password: passwordTextField.text!)
       
            UdacityClient.sharedInstance().taskForPOSTSession(methodType: UdacityClient.Methods.session, completionHandler: { (_ error) -> Void in
                
                DispatchQueue.main.async {
                    
                    guard (error == nil) else {
                        let errorMessage = UIAlertController.init(title: "Error", message: "Please check username and password.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        errorMessage.addAction(okAction)
                        self.present(errorMessage, animated: true)
                        self.activityIndicator.stopAnimating()
                        return
                    }
                }
                
                let tabBarController = (self.storyboard?.instantiateViewController(withIdentifier: "TabBarController"))! as UIViewController
                self.present(tabBarController, animated: true, completion: nil) })
            
            self.activityIndicator.stopAnimating()
            
        } else {
            
            let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter both an email and password.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
            
            errorMessage.addAction(okAction)
            
            self.present(errorMessage, animated: true)
        }
        
    } // End loginButtonPressed
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        let app = UIApplication.shared
        app.open(URL(string: UdacityClient.UdacityConstants.udacitySignupURL)!, options: [:], completionHandler: nil)
    }
    
    
} // End LoginViewController

