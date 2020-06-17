//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Chantal Deguire on 2020-05-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var userName: TextField!
    @IBOutlet weak var userPassword: TextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up FBLogin Button
        let fbLoginButton = FBLoginButton()
        fbLoginButton.center = view.center
        view.addSubview(fbLoginButton)
        
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            StudentLocation.Auth.accountKey = AccessToken.current!.tokenString
            self.handleSessionResponse(success: true, error: nil)
            
        }
        
        // Observe access token changes
        // This will trigger after successfully login / logout
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            
            // Print out access token
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
            
            //If student has signed in via Facebook
            if let token = AccessToken.current,
                !token.isExpired {
                // User is logged in, do work such as go to next view controller.
                StudentLocation.Auth.accountKey = AccessToken.current!.tokenString
                self.handleSessionResponse(success: true, error: nil)
                
            }
        }
        
    
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userName.text = ""
        userPassword.text = ""
        
    }
    
    //MARK: - IBActions
    @IBAction func logginTapped(_ sender: Any) {
        setLoggingIn(true)
        StudentLocation.createSessionId(username: userName.text ?? "", password: userPassword.text ?? "", completion: handleSessionResponse(success:error:))
        print(StudentLocation.Auth.sessionId)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(StudentLocation.EndPoints.webAuth.url, options: [:], completionHandler: nil)
    }
    
    //MARK: - Internal Class Functions
    func setLoggingIn(_ loggingIn: Bool) {
        
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        userName.isEnabled = !loggingIn
        userPassword.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signUpButton.isEnabled = !loggingIn
    
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            StudentLocation.getPublicUserData(userId: StudentLocation.Auth.accountKey) { success, error in
                if success {
                    print(StudentLocation.PublicUserInfo.firstName)
                } else { //handle error
                    AlertVC.showMessage(title: "Cannot Get Public User Data", msg: error?.localizedDescription ?? "", on: self)
                }
                
            }
            performSegue(withIdentifier: "completeLogin", sender: nil)
            
        } else {
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

