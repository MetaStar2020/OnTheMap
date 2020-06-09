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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*//need more tweaking here!  hint: maybe I need the delegate?
        //userName.position(from: userName.beginningOfDocument, offset: 5)
        if let newPosition = userName.position(from: userName.beginningOfDocument, offset: 15) {

            userName.selectedTextRange = userName.textRange(from: newPosition, to: newPosition)
        }
        userPassword.position(from: userName.beginningOfDocument, offset: 5)
        // check: textField.textRange(from: , to: ) and https://stackoverflow.com/a/34922332 */
        
        userName.text = ""
        userPassword.text = ""
    }
    
    @IBAction func logginTapped(_ sender: Any) {
        //setLoggingIn(true)
        StudentLocation.createSessionId(username: userName.text ?? "", password: userPassword.text ?? "", completion: handleSessionResponse(success:error:))
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        //setLoggingIn(false)
        //skip handling to test app
        performSegue(withIdentifier: "completeLogin", sender: nil)
        /*if success {
            print("Session succeeded! - completeLogin is the next step")
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            print("Session failed")
            //showLoginFailure(message: error?.localizedDescription ?? "")
        }*/
    }
}

