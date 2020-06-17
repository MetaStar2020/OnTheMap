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
    
    //MARK: - Class Properties
    let fbLoginButton = FBLoginButton()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Log out first in case it is logged in before
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logOut()
        
        //Set up FBLogin Button
        fbLoginButton.center = view.center
        view.addSubview(fbLoginButton)
        //self.setupFacebookButton()
        
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            StudentLocation.createFBSessionId(fbToken: AccessToken.current!.tokenString, completion: self.handleSessionResponse(success:error:))
            
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
                //StudentLocation.Auth.accountKey = AccessToken.current!.tokenString
                StudentLocation.createFBSessionId(fbToken: AccessToken.current!.tokenString, completion: self.handleSessionResponse(success:error:))
                //self.handleSessionResponse(success: true, error: nil)
                
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

//FBLogin Delegate
extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            AlertVC.showMessage(title: "Facebook Login Failed", msg: error?.localizedDescription ?? "", on: self)
            return
        }
        
        //self.performFBLogin(result!.token!.tokenString)
    }
    
    /*func performFBLogin(_ fbToken: String) {
        StudentLocation.sharedInstance().performFacebookLogin(fbToken, completionHandlerFBLogin: { (error) in
            
            if (error == nil) {
                
                // Get User Info
                self.getCurrentUserInfo()
                
                // Complete Login
                performSegue(withIdentifier: "completeLogin", sender: nil)
            }
            else {
                AlertVC.showMessage(title: "Invalid Login or Password", msg: error?.localizedDescription ?? "", on: self)
            }
        })
    }*/
    
    func setupFacebookButton() {
        NSLayoutConstraint(item: fbLoginButton,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerXWithinMargins,
                           multiplier: 1.0,
                           constant: 0)
            .isActive = false
        
        NSLayoutConstraint(item: fbLoginButton,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.loginButton,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 20)
            .isActive = false
        
        NSLayoutConstraint(item: fbLoginButton,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.loginButton,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -20)
            .isActive = true
        
        NSLayoutConstraint(item: fbLoginButton,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.loginButton,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0)
            .isActive = false
        
        fbLoginButton.delegate = self
    }
    
}

