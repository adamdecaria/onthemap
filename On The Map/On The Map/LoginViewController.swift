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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    // ensure textField puts the keyboard away after use
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        return textField.resignFirstResponder()
        
    } // end textFieldShouldReturn
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {

        if emailTextField.hasText && passwordTextField.hasText {
            
            UdacityClient.sharedInstance().getLoginInfo(username: emailTextField.text!, password: passwordTextField.text!)
            
            UdacityClient.sharedInstance().taskForPOSTSession(methodType: UdacityClient.Methods.session, completionHandler: { () -> Void in
                let mapViewController = (storyboard?.instantiateViewController(withIdentifier: "MapViewController"))! as UIViewController
                self.present(mapViewController, animated: true, completion: nil) })
            
        } else {
            
            let errorMessage = UIAlertController.init(title: "Forgot Something...", message: "Please enter both an email and password.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
            
            errorMessage.addAction(okAction)
            
            self.present(errorMessage, animated: true)
        }
        
    } // End loginButtonPressed
    
} // End LoginViewController

