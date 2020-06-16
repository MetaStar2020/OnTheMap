//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-05-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // Outlets
    //@IBOutlet weak var userName: UITextField!
    //@IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userName: TextField!
    @IBOutlet weak var userPassword: TextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userName.text = ""
        userPassword.text = ""
    }
    
    @IBAction func logginTapped(_ sender: Any) {
        setLoggingIn(true)
        StudentLocation.createSessionId(username: userName.text ?? "", password: userPassword.text ?? "", completion: handleSessionResponse(success:error:))
        print(StudentLocation.Auth.sessionId)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(StudentLocation.EndPoints.webAuth.url, options: [:], completionHandler: nil)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        userName.isEnabled = !loggingIn
        userPassword.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        //skip handling to test app
        if success {
            print("Session succeeded! - completeLogin is the next step")
            
            StudentLocation.getPublicUserData(userId: StudentLocation.Auth.accountKey) { success, error in
                if success {
                    print(StudentLocation.PublicUserInfo.firstName)
                } else {
                    //handle error
                    print("error with getPublicUserData")
                }
                
            }
            
            
            
            performSegue(withIdentifier: "completeLogin", sender: nil)
            
        } else {
            print("Session failed")
            AlertVC.showMessage(title: "Session Failed", msg: error?.localizedDescription ?? "", on: self)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Need to do something here only if its the userPassword Textfield that is selected.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

